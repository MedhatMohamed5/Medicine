import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/screens/auth_screens/complete_profile.dart';
import 'package:dr_ahmed_medicine/screens/auth_screens/login_screen.dart';
import 'package:dr_ahmed_medicine/screens/customizations/loading.dart';
import 'package:dr_ahmed_medicine/screens/home_screen.dart';
import 'package:dr_ahmed_medicine/user/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Loading(Colors.red, Colors.blue, Colors.yellow),
                ),
              );
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              break;
            case ConnectionState.none:
              break;
          }
          if (snapshot.hasData) {
            return StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection(Profile.kEntity)
                  .document(snapshot.data.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Scaffold(
                      appBar: AppBar(),
                      body: Center(
                        child: Loading(Colors.red, Colors.blue, Colors.yellow),
                      ),
                    );
                    break;
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    break;
                  case ConnectionState.none:
                    break;
                }
                if (snapshot.hasData) {
                  if (snapshot.data.data != null) {
                    print('data document id ' +
                        snapshot.data.data.length.toString());
                    return HomeScreen();
                  }
                }
                return CompleteProfile();
              },
            );
            /*HomeScreen();
            CompleteProfile();

            return HomeScreen();*/
          } else {
            return LoginScreen();
          }
        });
  }

  FirebaseUser getCurrentUser() {
    FirebaseUser user;
    FirebaseAuth.instance.currentUser().then((value) {
      user = value;
    });
    return user;
  }

  //Sign out
  signOut() async {
    FirebaseAuth.instance.signOut();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("user_id");
    sharedPreferences.remove("user_name");
    sharedPreferences.remove("user_phone");
  }

  //SignIn
  Future<void> signIn(AuthCredential authCredentials) async {
    await FirebaseAuth.instance.signInWithCredential(authCredentials);
    await saveSharedPref();
  }

  Future<void> signInWithOTP(smsCode, verId) async {
    AuthCredential authCredentials = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    await signIn(authCredentials);
  }

  Future<void> saveSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    FirebaseAuth.instance.currentUser().then((value) {
      sharedPreferences.setString("user_id", value.uid);
      sharedPreferences.setString("user_phone", value.phoneNumber);
      Firestore.instance
          .collection(Profile.kEntity)
          .document(value.uid)
          .snapshots()
          .first
          .then((value) {
        if (value.data != null) {
          sharedPreferences.setString("user_name", value.data[Profile.kName]);
        }
      });
    });
  }
}
