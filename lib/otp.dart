import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:personal_budget/main.dart';
import './screens/create_join_family.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String userName;
  OTPScreen(this.phone, this.userName);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: HexColor("#FDD2BF"),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: HexColor("#DF5E5E"),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("#E98580"),
        centerTitle: true,
        title: Text('OTP Verification'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: HexColor("#E98580"),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                  child:
                      Image.asset("assets/images/book.jpg", fit: BoxFit.cover),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 30),
                  child: Text(
                    'Please enter the verification code sent to +91 ${widget.phone}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w200, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: PinPut(
                    fieldsCount: 6,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    textStyle:
                        const TextStyle(fontSize: 25.0, color: Colors.black),
                    eachFieldWidth: 40.0,
                    eachFieldHeight: 55.0,
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: pinPutDecoration,
                    selectedFieldDecoration: pinPutDecoration,
                    followingFieldDecoration: pinPutDecoration,
                    pinAnimationType: PinAnimationType.fade,
                    onSubmit: (pin) async {
                      try {
                        await FirebaseAuth.instance
                            .signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: _verificationCode,
                                smsCode: pin))
                            .then((value) async {
                          if (value.user != null) {
                            print(FirebaseAuth.instance.currentUser.uid);
                            final prefs = await SharedPreferences.getInstance();
                            userMain = widget.userName;
                            final userData = json.encode(
                              {
                                "token": "iuagd",
                                "userId": FirebaseAuth.instance.currentUser.uid,
                                "displayName": widget.phone,
                                "email": widget.userName,
                                "url": ""
                              },
                            );
                            prefs.setString("userData", userData);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateJoinFamily()),
                                (route) => false);
                          }
                        });
                      } catch (e) {
                        FocusScope.of(context).unfocus();
                        _scaffoldkey.currentState.showSnackBar(
                            SnackBar(content: Text('Invalid OTP')));
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    print("object");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              print(FirebaseAuth.instance.currentUser.uid);
              final prefs = await SharedPreferences.getInstance();
              final userData = json.encode(
                {
                  "token": "iuagd",
                  "userId": FirebaseAuth.instance.currentUser.uid,
                  "displayName": widget.phone,
                  "email": widget.userName,
                  "url": ""
                },
              );
              prefs.setString("userData", userData);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => CreateJoinFamily()),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
