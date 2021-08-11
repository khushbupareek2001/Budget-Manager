import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/transaction_list.dart';
import '../widgets/new_transaction.dart';
import '../widgets/chart.dart';

import '../models/transaction.dart';
// import './widgets/new_transaction.dart';
// import './widgets/transaction_list.dart';
// import 'package:intl/intl.dart';

// import './models/transaction.dart';

// void main() => runApp(MyApp());

class PersonalExpenses extends StatefulWidget {
  // bool isCreate;
  // PersonalExpenses(this.isCreate);
  static const routeName = "/personal_expenses";
  @override
  _PersonalExpensesState createState() => _PersonalExpensesState();
}

class _PersonalExpensesState extends State<PersonalExpenses> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Manager',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        // errorColor: Colors.red,
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
  // final List<Transaction> transactions = [
  //   Transaction(
  //     id: 't1',
  //     title: 'New Shoes',
  //     amount: 70.23,
  //     date: DateTime.now(),
  //   ),
  //   Transaction(
  //     id: 't2',
  //     title: 'Weekly Groceries',
  //     amount: 20.12,
  //     date: DateTime.now(),
  //   ),
  // ];

  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // final titleController = TextEditingController();
  // final amountController = TextEditingController();

  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 70.23,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 20.12,
    //   date: DateTime.now(),
    // ),
  ];
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
    return _userTransactions.where((tx) {
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
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
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
      title: Text('Budget Manager'),
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
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    return Scaffold(
      appBar: appBar,
      // appBar: AppBar(
      //     title: Text('Personal Expenses'),
      //     actions: <Widget>[
      //       IconButton(
      //         icon: Icon(Icons.add),
      //         onPressed: () => _startAddNewTransaction(context),
      //       ),
      //     ],
      // ),
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

            // : Container(
            //     height: (MediaQuery.of(context).size.height -
            //             appBar.preferredSize.height -
            //             MediaQuery.of(context).padding.top) *
            //         0.7,
            //     child:
            //         TransactionList(_userTransactions, _deleteTransaction),
            //   ),

            // Container(
            //   width: double.infinity,
            //   child: Card(
            //     color: Colors.blue,
            //     child: Text('CHART!'),
            //     elevation: 5,
            //   ),
            // ),

            // Card(
            //   elevation: 5,
            //   child: Container(
            //     padding: EdgeInsets.all(10),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.end,
            //       children: <Widget>[
            //         TextField(
            //           decoration: InputDecoration(labelText: 'Title'),
            //           // onChanged: (val) {
            //           //   titleInput = val;
            //           // },
            //           controller: titleController,
            //         ),
            //         TextField(
            //           decoration: InputDecoration(labelText: 'Amount'),
            //           // onChanged: (val) => amountInput = val,
            //           controller: amountController,
            //         ),
            //         FlatButton(
            //           child: Text('Add Transaction'),
            //           textColor: Colors.purple,
            //           onPressed: () {
            //             // print(titleInput);
            //             // print(amountInput);
            //             print(titleController.text);
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // NewTransaction(),

            // Card(
            //   color: Colors.red,
            //   child: Text('LIST OF TX'),
            // ),
            // Column(
            //   children: transactions.map((tx) {
            //     return Card(
            //       child: Row(
            //         children: <Widget>[
            //           Container(
            //             margin: EdgeInsets.symmetric(
            //               vertical: 10,
            //               horizontal: 15,
            //             ),
            //             decoration: BoxDecoration(
            //               border: Border.all(
            //                 color: Colors.purple,
            //                 width: 2,
            //               ),
            //             ),
            //             padding: EdgeInsets.all(10),
            //             child: Text(
            //               // tx.amount.toString(),
            //               '\$${tx.amount}',
            //               style: TextStyle(
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 20,
            //                 color: Colors.purple,
            //               ),
            //             ),
            //           ),
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: <Widget>[
            //               Text(
            //                 tx.title,
            //                 style: TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //               Text(
            //                 // tx.date.toString(),
            //                 // DateFormat('yyyy/MM/dd').format(tx.date),
            //                 DateFormat.yMMMd().format(tx.date),
            //                 style: TextStyle(
            //                   color: Colors.grey,
            //                 ),
            //               ),
            //             ],
            //           )
            //         ],
            //       ),
            //     );
            //   }).toList(),
            // ),

            // TransactionList(),
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
