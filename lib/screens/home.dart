import 'package:draw_graph/models/feature.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_budget/main.dart';
import 'package:personal_budget/screens/personal_expenses.dart';
import 'package:personal_budget/screens/reminder.dart';
import 'package:personal_budget/screens/wishlist.dart';
import '../widgets/transaction_list.dart';
import '../widgets/new_transaction.dart';
import '../widgets/chart.dart';
import 'package:provider/provider.dart';
import '../models/auth.dart';
import '../models/transaction.dart';
import 'package:share/share.dart';
import 'package:personal_budget/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  bool isCreate;
  Home(this.isCreate);
  @override
  _HomeState createState() => _HomeState();
}

// class Feature {
//   String title;
//   Color color;
//   List<double> data;
//   Feature(this.title, this.color, this.data);
// }

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/personal_expenses": (ctx) => PersonalExpenses(),
        "/wishlist": (ctx) => WishList(),
        "/reminder": (ctx) => Reminder(),
      },
      title: 'Budget Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _showChart = false;
  final Color darkBlue = Color.fromARGB(255, 18, 32, 47);
  final List<Feature> features = [
    Feature(
      title: "Total Expenditure",
      color: Colors.green,
      data: [0.2, 0.8, 0.4, 0.7, 0.6],
    ),
    Feature(
      title: "Remaining Income",
      color: Colors.red,
      data: [1, 0.8, 0.6, 0.7, 0.3],
    ),
    // Feature(
    //   title: "Study",
    //   color: Colors.cyan,
    //   data: [0.5, 0.4, 0.85, 0.4, 0.7],
    // ),
    // Feature(
    //   title: "Water Plants",
    //   color: Colors.green,
    //   data: [0.6, 0.2, 0, 0.1, 1],
    // ),
    // Feature(
    //   title: "Grocery Shopping",
    //   color: Colors.amber,
    //   data: [0.25, 1, 0.3, 0.8, 0.6],
    // ),
  ];

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

  Future<void> logout() async {
    // if (googleSignIn.currentUser != null) {
    //   await googleSignIn.disconnect();
    //   FirebaseAuth.instance.signOut();
    // }
    // notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
  }

  List<Transaction> get _recentTransactions {
    return userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  // void _addNewTransaction(
  //     String txTitle, double txAmount, DateTime chosenDate) {
  //   final newTx = Transaction(
  //     id: DateTime.now().toString(),
  //     title: txTitle,
  //     amount: txAmount,
  //     date: chosenDate,
  //   );

  //   setState(() {
  //     userTransactions.add(newTx);
  //   });
  // }

  // void _startAddNewTransaction(BuildContext ctx) {
  //   showModalBottomSheet(
  //     context: ctx,
  //     builder: (_) {
  //       return GestureDetector(
  //         onTap: () {},
  //         behavior: HitTestBehavior.opaque,
  //         child: NewTransaction(_addNewTransaction),
  //       );
  //     },
  //   );
  // }

  void _deleteTransaction(String id) {
    setState(() {
      userTransactions.removeWhere((tx) {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 64.0),
                    child: Text(
                      "Tasks Track",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  LineGraph(
                    features: features,
                    size: Size(320, 300),
                    labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'],
                    labelY: ['20%', '40%', '60%', '80%', '100%'],
                    showDescription: true,
                    graphColor: Colors.white30,
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
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
            0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Container(),
            LineGraph(
              features: features,
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height * 0.3),
              labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'],
              labelY: ['20%', '40%', '60%', '80%', '100%'],
              showDescription: true,
              graphColor: Colors.white30,
            ),
            // SizedBox(
            //   height: 50,
            // )
          ],
        ),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text('Budget Manager'),
      // actions: <Widget>[
      //   IconButton(
      //     icon: Icon(Icons.add),
      //     onPressed: () => _startAddNewTransaction(context),
      //   ),
      // ],
    );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(personalTransactions, _deleteTransaction, false),
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
                  Navigator.of(context).pop();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.attach_money_rounded),
                title: const Text("Personal Expenses"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PersonalExpenses(),
                    ),
                  );
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
      body: SingleChildScrollView(
        child: Column(
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () => _startAddNewTransaction(context),
      // ),
    );
  }
}
