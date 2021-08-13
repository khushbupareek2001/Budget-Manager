import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import './models/web_response_extractor.dart';
import 'otp.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("#E98580"),
        centerTitle: true,
        title: const Text('Verification'),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      // padding: EdgeInsets.all(
                      //     MediaQuery.of(context).size.width * 0.1),
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.1,
                          MediaQuery.of(context).size.width * 0.1,
                          MediaQuery.of(context).size.width * 0.1,
                          0),

                      child: Image.asset("assets/images/TransparentLogo.png",
                          fit: BoxFit.cover),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 60, right: 30, left: 30),
                      alignment: Alignment.center,
                      child: Text(
                        'Please enter your mobile number to receive a verification code',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w200, fontSize: 20),
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 40, right: 10, left: 10),
                    //   child: TextField(
                    //     decoration: InputDecoration(
                    //       hintText: 'User Name',
                    //     ),
                    //     maxLength: 10,
                    //     keyboardType: TextInputType.text,
                    //     controller: _userNameController,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                      child: TextFormField(
                        controller: _userNameController,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.verified_user_outlined,
                            color: Colors.grey[450],
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius:
                                BorderRadius.all(Radius.circular(35.0)),
                          ),
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'User Name',
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 40, right: 10, left: 10),
                    //   child: TextField(
                    //     decoration: InputDecoration(
                    //       hintText: 'Phone Number',
                    //       prefix: Padding(
                    //         padding: EdgeInsets.all(4),
                    //         child: Text('+91'),
                    //       ),
                    //     ),
                    //     maxLength: 10,
                    //     keyboardType: TextInputType.number,
                    //     controller: _controller,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _controller,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          // prefixIcon: Icon(
                          //   Icons.verified_user_outlined,
                          //   color: Colors.grey[450],
                          // ),
                          prefix: Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('+91'),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius:
                                BorderRadius.all(Radius.circular(35.0)),
                          ),
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'Mobile Number',
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        maxLength: 10,
                      ),
                    ),
                  ],
                ),
                Container(
                  // margin: EdgeInsets.all(10),
                  // padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  // height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),

                  child: ElevatedButton(
                    // color: HexColor("#DF5E5E"),
                    style:
                        ElevatedButton.styleFrom(primary: HexColor("#DF5E5E")),
                    onPressed: () {
                      if (_userNameController.text.isEmpty)
                        WebResponseExtractor.showToast(
                            "Please Enter your User Name");
                      else if (_controller.text.isEmpty)
                        WebResponseExtractor.showToast(
                            "Please Enter your Mobile Number");
                      else if (_controller.text.length != 10) {
                        WebResponseExtractor.showToast(
                            'Please Enter a Valid Mobile Number');
                      } else if (int.parse(_controller.text[0]) != 6 &&
                          int.parse(_controller.text[0]) != 7 &&
                          int.parse(_controller.text[0]) != 8 &&
                          int.parse(_controller.text[0]) != 9) {
                        WebResponseExtractor.showToast(
                            'Please Enter a Valid Mobile Number');
                      } else
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OTPScreen(
                                _controller.text, _userNameController.text)));
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
