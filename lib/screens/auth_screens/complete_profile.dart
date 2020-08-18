import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/screens/customizations/constants.dart';
import 'package:dr_ahmed_medicine/screens/home_screen.dart';
import 'package:dr_ahmed_medicine/user/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteProfile extends StatefulWidget {
  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  SharedPreferences sharedPreferences;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    getShared();
    super.initState();
  }

  getShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome !'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/medicine_icon.png',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  sharedPreferences != null
                      ? Text(
                          'Welcome ${sharedPreferences.getString("user_phone")} please complete you profile!',
                          style: TextStyle(
                            letterSpacing: 1.3,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(""),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: controller,
                    textCapitalization: TextCapitalization.words,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Name',
                      hintText: 'Enter your name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Please enter your name';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      'Confirm !',
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 16),
                    ),
                    onPressed: completeProfile,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void completeProfile() async {
    if (formKey.currentState.validate()) {
      Firestore.instance
          .collection(Profile.kEntity)
          .document(sharedPreferences.getString("user_id"))
          .setData({
        Profile.kPhone: sharedPreferences.get("user_phone"),
        Profile.kName: controller.text,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }
}
