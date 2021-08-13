import 'package:flutter/material.dart';
import 'package:personal_budget/models/transaction.dart';
import 'package:personal_budget/screens/home.dart';
import 'package:personal_budget/screens/personal_expenses.dart';
// import 'package:silaiclub/login.dart';
import '../models/web_response_extractor.dart';
import '../models/auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:personal_budget/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishList extends StatefulWidget {
  bool isCreate;
  WishList([this.isCreate]);
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  Future<void> logout() async {
    // if (googleSignIn.currentUser != null) {
    //   await googleSignIn.disconnect();
    //   FirebaseAuth.instance.signOut();
    // }
    // notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40),
                height: MediaQuery.of(context).size.height * 0.28,
                //color: Colors.brown[400],
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue[400],
                      Colors.lightBlue[100],
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (userUrl == null || userUrl == "")
                                ? AssetImage("assets/images/uservector.jpg")
                                : NetworkImage(
                                    userUrl,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        userMain == null ? "User123" : userMain,
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.002),
                      Text(
                        userEmail == null ? "user@gmail.com" : userEmail,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        "Remaining Income: ₹" + familyMoney.toString(),
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: const Text("Home"),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => Home(widget.isCreate),
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.attach_money_rounded),
                title: const Text("Personal Expenses"),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => PersonalExpenses(widget.isCreate),
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.favorite),
                title: const Text("WishList"),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.lock_clock),
                title: const Text("Reminder"),
                onTap: () {
                  Navigator.of(context).pushNamed("/reminder");
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.share),
                title: const Text("Share"),
                onTap: () {
                  final RenderBox renderBox = context.findRenderObject();

                  Share.share(
                    'Hello User, Please Download the App Now:\n',
                    sharePositionOrigin:
                        renderBox.localToGlobal(Offset.zero) & renderBox.size,
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.info),
                title: const Text("About"),
                onTap: () {
                  // Navigator.of(context).pushNamed(About.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.feedback),
                title: const Text("FeedBack"),
                onTap: () {
                  final email = "himanshudasingh@gmail.com";
                  launch("mailto:$email?subject=Feedback");
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: const Text("Logout"),
                onTap: () {
                  logout();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                      (Route<dynamic> route) => false);
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: wishList.length,
              itemBuilder: (ctx, i) => CartItem(
                wishList[i].id,
                wishList[i].title,
                wishList[i].amount,
                wishList[i].date,
                context,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget CartItem(
    final String id,
    final String title,
    final double amount,
    final DateTime date,
    BuildContext context,
  ) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                  WebResponseExtractor.showToast(
                      "Removed to WishList Successfully.");
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        wishList.removeWhere((element) => element.id == id);

        // Provider.of<Transaction>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$$amount'),
                ),
              ),
            ),
            title: Text(title),
            // subtitle: Text('Total: \$${(amount * amount)}'),
            subtitle: Text("date"),
            // trailing: Text('$date x'),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  personalTransactions.add(Transaction(
                      id: id, title: title, amount: amount, date: date));
                  familyMoney = familyMoney - amount;
                  wishList.removeWhere((element) => element.id == id);
                });
                WebResponseExtractor.showToast(
                    "Added to Transaction Successfully.");

                // Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.done,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
