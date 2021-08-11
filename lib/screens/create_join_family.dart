import 'package:flutter/material.dart';
import './home.dart';

class CreateJoinFamily extends StatelessWidget {
  static const routeName = "/-gender-screen";
  final male = "M";
  final female = "F";
  final kids = "K";

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.lime[50],
      body: Stack(children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Container(
            height: height,
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //       image: const AssetImage("assets/images/backlogo1.jpeg"),
            //       fit: BoxFit.cover),
            // ),
            child: Container(
              padding: EdgeInsets.only(left: width * 0.04, top: height * 0.12),
              color: Color(0xFFEFEBE9).withOpacity(.65),
            ),
          ),
        ),
        // Positioned(
        //   left: height * 0.01,
        //   right: height * 0.01,
        //   top: height * 0.05,
        //   // bottom: height * 0.5,
        //   child: Container(
        //     padding: EdgeInsets.all(width * 0.1),
        //     child:Text(""),
        //   ),
        //   // color: Color(0xFFEFEBE9).withOpacity(.55),
        // ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.08),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Home()),
                      );
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
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: const AssetImage(
                              "assets/images/women.jpg",
                            ),
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
