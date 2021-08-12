import 'package:flutter/material.dart';
import 'package:personal_budget/screens/create_join_family.dart';
import 'package:personal_budget/screens/home.dart';
import 'package:provider/provider.dart';
// import 'package:silaiclub/screens/about_screen.dart';
// import 'package:silaiclub/screens/chat_screen.dart';
// import 'package:silaiclub/screens/intro_screen.dart';
// import 'package:silaiclub/screens/orders.dart';
// import 'package:silaiclub/screens/recent_chat.dart';
import './screens/auth_screen.dart';
// import './screens/category_screen.dart';
// import './screens/gender_screen.dart';
// import './screens/tailor_screen.dart';
// import './widgets/dummy_category.dart';
// import './widgets/tailors.dart';
// import './screens/add_tailor.dart';
import './models/auth.dart';
// import './screens/book.dart';
// import './widgets/bookdatas.dart';
// import './screens/booking_request.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'dart:async';

String userMain = "User";
String userEmail = "User@gmail.com";
String userUrl = "";
bool checkSignup = false;
String customerId;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SplashScreen());
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Container(
          // width: MediaQuery.of(context).size.width * 0.5,
          // height: MediaQuery.of(context).size.height * 0.5,
          child: Image.asset(
            "assets/images/spash.jpg",
            fit: BoxFit.cover,
          ),
        ),
        nextScreen: MyApp(),
        // backgroundColor: Colors.cyan,
        splashTransition: SplashTransition.scaleTransition,
        animationDuration: Duration(milliseconds: 300),
      ),
      routes: {
        // IntroScreen.routeName: (ctx) => IntroScreen(),
        MyApp.routeName: (ctx) => MyApp(),
        // ChatScreen.routeName: (ctx) => ChatScreen()
      },
    );
  }
}

class MyApp extends StatefulWidget {
  static const routeName = "/myapp";
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Future checkFirstSeen() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool _seen = (prefs.getBool('seen') ?? false);

  //   if (_seen) {
  //     AuthScreen();
  //   } else {
  //     await prefs.setBool('seen', true);
  //     Navigator.pushNamed(context, IntroScreen.routeName);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Budget Manager',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: auth.isAuth
              ? CreateJoinFamily()
              : FutureBuilder(
                  builder: (ctx, authresultSnapshot) =>
                      authresultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : AuthScreen(),
                  future: auth.tryAutoLogin(),
                ),
          routes: {
            // TailorScreen.routeName: (ctx) => TailorScreen(),
            // AddTailor.routename: (ctx) => AddTailor(),
            // CategoryScreen.routeName: (ctx) => CategoryScreen(),
            // Book.routeName: (ctx) => Book(),
            // BookingRequest.routeName: (ctx) => BookingRequest(false),
            // GenderScreen.routeName: (ctx) => GenderScreen(),
            // Orders.routeName: (ctx) => Orders(),
            // About.routeName: (ctx) => About(),
            // RecentChat.routeName: (ctx) => RecentChat()
            // ChatScreen.routeName: (ctx) => ChatScreen()
          },
        ),
      ),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   new Timer(new Duration(milliseconds: 200), () {
  //     checkFirstSeen();
  //   });
  // }
}
