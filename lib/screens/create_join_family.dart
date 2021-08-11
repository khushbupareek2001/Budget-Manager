import 'package:flutter/material.dart';
import 'package:personal_budget/main.dart';
import 'package:personal_budget/models/web_response_extractor.dart';
import './home.dart';

class CreateJoinFamily extends StatelessWidget {
  static const routeName = "/-gender-screen";
  bool isCreate = true;
  int role = 0;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(children: [
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
          // left: width * 0.1,
          // right: width * 0.1,
          top: height * 0.1,
          child: Container(
            // height: height,
            // width: width,
            padding: EdgeInsets.all(width * 0.1),
            child: Text(
              "Welcome,",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        Positioned(
          // left: width * 0.1,
          // right: width * 0.1,
          top: height * 0.15,
          child: Container(
            // height: height,
            // width: width,
            padding: EdgeInsets.all(width * 0.1),
            child: Text(
              userEmail.replaceAll("@gmail.com", ""),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Positioned(
        //   left: width * 0.01,
        //   right: width * 0.03,
        //   top: height * 0.25,
        //   child: Container(
        //     // height: height,
        //     // width: width,
        //     padding: EdgeInsets.all(width * 0.1),
        //     child: Text(
        //       "Record the details of your expenses and savings with your family",
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //         fontSize: 15,
        //         fontWeight: FontWeight.w400,
        //         fontStyle: FontStyle.italic,
        //       ),
        //     ),
        //   ),
        // ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      TextEditingController controller =
                          TextEditingController();
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return new AlertDialog(
                              title: new Text("Personal Details"),
                              content: Column(
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: "Family Head Name"),
                                    // initialValue: "",
                                    controller: controller,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText:
                                            "Enter Id"), //Radio Buttons for designation
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      if (controller.text.isEmpty)
                                        WebResponseExtractor.showToast(
                                            "Please Enter Your Name");
                                      else {
                                        userMain = controller.text.toString();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => Home(true)),
                                        );
                                      }
                                    },
                                    child: Text("Enter"))
                              ],
                            );
                          });
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 60,
                            // backgroundImage: const AssetImage(
                            //   "assets/images/men.jfif",
                            // ),
                            backgroundColor: Colors.white,
                            child: Icon(Icons.add),
                          ),
                        ),
                        const Text(
                          "Create a Family",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      TextEditingController controller =
                          TextEditingController();
                      // controller.text = "";
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return new AlertDialog(
                              title: new Text("Enter Head Family Email Id"),
                              content: Column(
                                children: [
                                  TextFormField(
                                    decoration:
                                        InputDecoration(labelText: "Enter Id"),
                                    // initialValue: "Enter Id",
                                  ),
                                  TextFormField(
                                    // h
                                    decoration: InputDecoration(
                                        labelText: "Enter Your Name"),
                                    controller: controller,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: "Enter Your Name"),
                                    // initialValue:
                                    //     "Enter Your Name", //Radio Buttons for designation
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      if (controller.text.isEmpty)
                                        WebResponseExtractor.showToast(
                                            "Please Enter Your Name");
                                      else {
                                        userMain = controller.text.toString();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Home(false)),
                                        );
                                      }
                                    },
                                    child: Text("Enter"))
                              ],
                            );
                          });
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 60,
                            child: Icon(Icons.family_restroom),
                            backgroundColor: Colors.white,
                            // child: Icon(Icons.join),
                          ),
                        ),
                        const Text(
                          "Join a Family",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
