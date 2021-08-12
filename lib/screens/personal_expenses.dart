import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_budget/screens/home.dart';
import '../widgets/transaction_list.dart';
import '../widgets/new_transaction.dart';
import '../widgets/chart.dart';
import 'package:personal_budget/main.dart';
import '../models/transaction.dart';
import 'package:provider/provider.dart';
import '../models/auth.dart';
import 'package:share/share.dart';

class PersonalExpenses extends StatefulWidget {
  static const routeName = "/personal_expenses";
  bool isCreate;
  PersonalExpenses([this.isCreate]);
  @override
  _PersonalExpensesState createState() => _PersonalExpensesState();
}

class _PersonalExpensesState extends State<PersonalExpenses>
    with WidgetsBindingObserver {
  // final  = [];
  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return personalTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      personalTransactions.add(newTx);
    });
  }

  void _addNewWishTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      wishList.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction, _addNewWishTransaction),
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      personalTransactions.removeWhere((tx) {
        familyMoney = familyMoney + tx.amount;
        return tx.id == id;
      });
    });
  }

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  1,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      backgroundColor: Colors.blue,
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(personalTransactions, _deleteTransaction, true),
    );
    return Scaffold(
      appBar: appBar,
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
                  Navigator.of(context).push(
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
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.favorite),
                title: const Text("WishList"),
                onTap: () {
                  Navigator.of(context).pushNamed("/wishlist");
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
                  // launch("mailto:$email?subject=Feedback");
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: const Text("Logout"),
                onTap: () {
                  Provider.of<Auth>(context, listen: false).logout();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed("/");
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
            if (!isLandscape)
              ..._buildPortraitContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
