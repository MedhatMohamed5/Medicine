// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/auth_service.dart';
// import 'package:dr_ahmed_medicine/screens/auth_screens/complete_profile.dart';
import 'package:dr_ahmed_medicine/screens/customizations/constants.dart';
import 'package:dr_ahmed_medicine/screens/customizations/loading.dart';
// import 'package:dr_ahmed_medicine/screens/home_screen.dart';
// import 'package:dr_ahmed_medicine/user/profile.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String _phone, verificationId, smsCode;

  bool codeSent = false;

  bool isLoading = false;
  RegExp phoneReg = RegExp(r'^01[0-9]{9}$');

  TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.blue[300],
      body: Center(
        child: Form(
          key: _globalKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/medicine_icon.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Text(
                          'Medicines',
                          style: TextStyle(
                            fontFamily: 'Sriracha',
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * .1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.white,
                  decoration: inputDecoration.copyWith(
                    icon: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    hintText: 'Mobile Phone',
                    labelText: 'Mobile Phone',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.white)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.red[300])),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.red[300])),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (!phoneReg.hasMatch(value))
                        return 'Please enter valid number';
                      return null;
                    } else {
                      return 'Please insert your phone number';
                    }
                  },
                ),
              ),
              SizedBox(
                height: height * .05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Builder(
                  builder: (context) => FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.black,
                    onPressed: _login
                    /*
                      setState(() {
                        isLoading = true;
                      });
                      if (_globalKey.currentState.validate()) {
                        _globalKey.currentState.save();
                        checkInternetConnectivity().then((value) {
                          if (value) {
                            validate(context, _phone, '', false);
                          } else {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Please Check your Internet Connection'),
                              ),
                            );
                          }
                        });

                        /*validate(context, _phone, '', false).then((value) {
                          var isConnected =
                              checkInternetConnectivity().then((value) {
                            if (!value) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Please Check your Internet Connection'),
                                ),
                              );
                            }
                          });
                        });*/
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }*/
                    ,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * .05,
              ),
              Offstage(
                offstage: !isLoading,
                child: Loading(
                  Colors.greenAccent,
                  Colors.blueAccent,
                  Colors.redAccent,
                ),
              ),
              codeSent
                  ? Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: otpController,
                        keyboardType: TextInputType.phone,
                        decoration: inputDecoration.copyWith(
                          icon: Icon(
                            Icons.message,
                            color: Colors.white,
                          ),
                          hintText: 'Enter OTP',
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.white)),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.red[300])),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.red[300])),
                          disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                        onChanged: (val) {
                          setState(() {
                            this.smsCode = val;
                          });
                        },
                        validator: (value) {
                          if (codeSent && value.length != 6) {
                            return 'Enter valid OTP';
                          }
                          return null;
                        },
                      ),
                    )
                  : Container(),
              SizedBox(
                height: height * .05,
              ),
              codeSent
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: Builder(
                        builder: (context) => FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.black,
                          onPressed: _login
                          /*
                      setState(() {
                        isLoading = true;
                      });
                      if (_globalKey.currentState.validate()) {
                        _globalKey.currentState.save();
                        checkInternetConnectivity().then((value) {
                          if (value) {
                            validate(context, _phone, '', false);
                          } else {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Please Check your Internet Connection'),
                              ),
                            );
                          }
                        });

                        /*validate(context, _phone, '', false).then((value) {
                          var isConnected =
                              checkInternetConnectivity().then((value) {
                            if (!value) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Please Check your Internet Connection'),
                                ),
                              );
                            }
                          });
                        });*/
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }*/
                          ,
                          child: Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              /*Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: RaisedButton(
                      child: Center(child: codeSent ? Text('Login'):Text('Verify')),
                      onPressed: () {
                        codeSent ? AuthService().signInWithOTP(smsCode, verificationId):verifyPhone(_phone);
                      }))*/
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_globalKey.currentState.validate()) {
      try {
        codeSent
            ? await AuthService().signInWithOTP(smsCode, verificationId)
            : await verifyPhone(_phone);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified =
        (AuthCredential authResult) async {
      await AuthService().signIn(authResult);

      /*SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      if (sharedPreferences.get("user_id") != null) {

      }*/
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+2" + phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
