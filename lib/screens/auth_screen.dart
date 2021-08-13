import 'package:flutter/material.dart';
import 'package:personal_budget/login.dart';
// import 'package:silaiclub/login.dart';
import '../models/web_response_extractor.dart';
import '../models/auth.dart';
import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:personal_budget/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin, ChangeNotifier {
  User user;
  final auth = FirebaseAuth.instance;
  Timer timer;
  @override
  AnimationController _controller;
  bool _isMale = true;
  bool isSignupScreen = false;
  bool isRememberMe = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool checking = false;
  TextEditingController email = TextEditingController(),
      password = TextEditingController(),
      userName = TextEditingController(),
      confirmPassword = TextEditingController();
  BuildContext dialogContext;
  Map<String, String> _authData = {'email': '', 'password': '', "userName": ''};
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text(
                "An Error Occured!",
                style: TextStyle(color: Colors.red),
              ),
              content: Text(message),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text(
                      "OKAY",
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (isSignupScreen == false) {
        CircularProgressIndicator();

        await Provider.of<Auth>(context, listen: false).login(
            _authData["email"], _authData["password"], _authData["userName"]);
        if (isRememberMe) {
          final prefs = await SharedPreferences.getInstance();
          final userRemember = json.encode({
            "email": _authData["email"],
            "password": _authData["password"],
          });

          prefs.setString("userRemember", userRemember);
        }
      } else {
        CircularProgressIndicator();
        await Provider.of<Auth>(context, listen: false).signup(
            _authData["email"], _authData["password"], _authData["userName"]);

        if (checkSignup == true)
          showDialog(
              context: context,
              builder: (BuildContext context) {
                dialogContext = context;
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: const Text(
                        "Please verify email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                          "A verification mail has been sent to ${_authData['email']}\nPlease verify it."),
                    );
                  },
                );
              });
        else
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "Error",
                  style: TextStyle(color: Colors.red),
                ),
                content: const Text("Please check data"),
              );
            },
          );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message);
    } catch (error) {
      const errorMessage = "Could not authenticate you. Please try again later";
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    preFilled();
    if (checkSignup == true) {
      user = auth.currentUser;
      user.sendEmailVerification();
      timer = Timer.periodic(Duration(seconds: 2), (timer) {
        checkEmailVerified();
      });
    }

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _controller.forward();

    super.initState();
  }

  Future<void> preFilled() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userRemember")) {
      return;
    }
    final extractUserData =
        json.decode(prefs.getString("userRemember")) as Map<String, Object>;
    setState(() {
      email.text = extractUserData["email"];
      password.text = extractUserData["password"];
      _authData["email"] = extractUserData["email"];
      _authData["password"] = extractUserData["password"];
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   top: 0,
          //   child: Container(
          //     height: height,
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //           image: const AssetImage("assets/images/backlogo.jpg"),
          //           fit: BoxFit.cover),
          //     ),
          //     child: Container(
          //       padding:
          //           EdgeInsets.only(left: width * 0.04, top: height * 0.12),
          //       color: Color(0xFFEFEBE9).withOpacity(.35),
          //     ),
          //   ),
          // ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  // Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                  Colors.blue[400],
                  Colors.lightBlue[50]
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          Positioned(
            left: width * 0.1,
            right: width * 0.1,
            top: height * 0.1,
            child: Container(
              // height: height,
              // width: width,
              padding: EdgeInsets.all(width * 0.1),
              child: Text(
                "Budget Manager",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            top: isSignupScreen ? height * 0.26 : height * 0.29,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              padding: EdgeInsets.all(20),
              height: isSignupScreen ? height * 0.48 : height * 0.32,
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: !isSignupScreen
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              ),
                              if (!isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: width * 0.16,
                                  color: Colors.cyan,
                                )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "SignUp",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSignupScreen
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                              ),
                              if (isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: width * 0.16,
                                  color: Colors.cyan,
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isSignupScreen) buildSignupScreen(),
                    if (!isSignupScreen) buildSigninScreen()
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              left: 0,
              right: 0,
              top: isSignupScreen ? height * 0.68 : height * 0.55,
              child: Center(
                child: Container(
                  height: height * 0.115,
                  width: height * 0.115,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : GestureDetector(
                          onTap: () {
                            if (isSignupScreen == true) {
                              if (password.text != confirmPassword.text)
                                WebResponseExtractor.showToast(
                                    // "Invalid Username and Password");
                                    "Password mismatch");
                              else
                                _submit();
                            } else
                              _submit();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.black87,
                                      Colors.blue[200],
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.3),
                                  )
                                ]),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              )),

          Positioned(
            top: MediaQuery.of(context).size.height - height * 0.14,
            left: 0,
            right: 0,
            child: TextButton(
              onPressed: () {
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => LoginScreen()),
                //     (route) => false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              style: TextButton.styleFrom(
                  minimumSize: Size(150, 40),
                  backgroundColor: Colors.blueGrey,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              child: const Text(
                "Login with Mobile Number",
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ]));
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      setState(() {
        checking = true;
      });
      timer.cancel();

      await Provider.of<Auth>(context, listen: false).checkEmail();
      notifyListeners();
      Navigator.pop(dialogContext);
    }
  }

  Container buildSigninScreen() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildTextField(
                Icons.mail_outline, "info@gmail.com", false, 1, email),
            buildTextField(
              Icons.lock_outline,
              "**********",
              true,
              2,
              password,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                        value: isRememberMe,
                        onChanged: (value) {
                          setState(() {
                            isRememberMe = !isRememberMe;
                          });
                        }),
                    const Text(
                      "Remember me",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildSignupScreen() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildTextField(
                Icons.verified_user_outlined, "User Name", false, 0, userName),
            buildTextField(Icons.email_outlined, "Email", false, 1, email),
            buildTextField(Icons.lock_outline, "Password", true, 2, password),
            buildTextField(Icons.lock_outline, "Confirm Password", true, 2,
                confirmPassword),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              padding: EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Terms and Conditions"),
                        content: const Text(
                            "For Customers:\n1.Companies will not be held liable for any product failure.\n2.The order completion timeline will begin on the day the product is delivered to the tailor.\n3.Customers have to visit the tailor to deliver or to receive the product.\n\nFor Tailors:\n1.Tailors are themselves responsible for their services.\n2.Tailors can charge their customers for their choice, but they have to charge 20% less than whatever they are charging for offline work.\n3.Tailors will be fired if they delay more than ten products.\n4.Tailors will be fired if they discover any fraud."),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OKAY",
                                  style: TextStyle(color: Colors.blue)))
                        ],
                      );
                    },
                  );
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "By pressing 'Submit' you agree to our ",
                      style: TextStyle(color: Colors.grey[400]),
                      children: [
                        TextSpan(
                          // recognizer: ,
                          text: "Terms & Conditions",
                          style: TextStyle(color: Colors.lightBlue),
                        )
                      ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      int isEmail, TextEditingController hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: hint,
        obscureText: isPassword,
        keyboardType:
            isEmail == 1 ? TextInputType.emailAddress : TextInputType.text,
        validator: isEmail == 1
            ? (value) {
                if (value.isEmpty || !value.contains('@')) {
                  return 'Invalid email!';
                }
              }
            : (value) {
                if (value.isEmpty || value.length < 3) {
                  return 'Too short!';
                }
              },
        onSaved: (value) {
          isEmail == 1
              ? _authData['email'] = value
              : (isEmail == 2
                  ? _authData['password'] = value
                  : _authData['userName'] = value);
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.grey[450],
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
