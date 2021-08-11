import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:personal_budget/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  Timer _authTimer;
  User user;
  final auth = FirebaseAuth.instance;
  Timer timer;

  // final googleSignIn = GoogleSignIn();
  bool _isSigningIn;

  Auth() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  // Future loginGoogle() async {
  //   isSigningIn = true;

  //   // final user = await googleSignIn.signIn();
  //   if (user == null) {
  //     isSigningIn = false;
  //     return;
  //   } else {
  //     // final googleAuth = await user.authentication;
  //     // _token = googleAuth.idToken;

  //     // final credential = GoogleAuthProvider.credential(
  //     //   accessToken: googleAuth.accessToken,
  //     //   idToken: googleAuth.idToken,
  //     );

  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     // _token = FirebaseAuth.instance.currentUser.uid;
  //     _userId = FirebaseAuth.instance.currentUser.uid;
  //     userMain = FirebaseAuth.instance.currentUser.displayName;
  //     userEmail = FirebaseAuth.instance.currentUser.email;
  //     userUrl = FirebaseAuth.instance.currentUser.photoURL;
  //     customerId = _userId;
  //     notifyListeners();
  //     final prefs = await SharedPreferences.getInstance();
  //     final userData = json.encode(
  //       {
  //         "token": _token,
  //         "userId": _userId,
  //         "displayName": userMain,
  //         "email": userEmail,
  //         "url": userUrl,
  //       },
  //     );
  //     prefs.setString("userData", userData);
  //     isSigningIn = false;
  //   }
  // }

  bool get isAuth {
    // if (googleSignIn.currentUser != null) {
    //   return true;
    // }
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, bool login, String userName) async {
    if (login == true) {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((_) async {
        _token = auth.currentUser.getIdToken().toString();
        _userId = auth.currentUser.uid;
        userMain = auth.currentUser.displayName;
        userEmail = auth.currentUser.email;
        userUrl = auth.currentUser.photoURL;
        customerId = _userId;
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            "token": _token,
            "userId": _userId,
            "displayName": userMain,
            "email": userEmail,
            "url": userUrl
          },
        );
        prefs.setString("userData", userData);
      });
    } else {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((_) {
        checkSignup = true;
        notifyListeners();
      });
    }
  }

  Future<void> checkEmail() async {
    _token = auth.currentUser.getIdToken().toString();
    _userId = auth.currentUser.uid;
    userMain = auth.currentUser.displayName;
    userEmail = auth.currentUser.email;
    userUrl = auth.currentUser.photoURL;
    customerId = _userId;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        "token": _token,
        "userId": _userId,
        "displayName": userMain,
        "email": userEmail,
        "url": userUrl
      },
    );
    prefs.setString("userData", userData);
    checkSignup = false;
  }

  Future<void> signup(String email, String password, String userName) async {
    return _authenticate(email, password, false, userName);
  }

  Future<void> login(String email, String password, String userName) async {
    return _authenticate(email, password, true, userName);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractUserData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    _token = extractUserData["token"];
    _userId = extractUserData["userId"];
    userMain = extractUserData["displayName"];
    userEmail = extractUserData["email"];
    userUrl = extractUserData["url"];
    customerId = _userId;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    // if (googleSignIn.currentUser != null) {
    //   await googleSignIn.disconnect();
    //   FirebaseAuth.instance.signOut();
    // }

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
  }
}
