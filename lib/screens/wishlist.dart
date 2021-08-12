import 'package:flutter/material.dart';
import 'package:personal_budget/models/transaction.dart';
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

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
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
              },
            ),
          ],
        ),
      );
    },
    onDismissed: (direction) {
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
          trailing: Icon(
            Icons.done,
            color: Colors.green,
          ),
        ),
      ),
    ),
  );
}
