import 'package:flutter/material.dart';
//  ?? import 'package:personal_budget/widgetss/transaction_list.dart';
import '../models/transaction.dart';
//import 'package:intl/intl.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.title,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        // : ListView.builder(
        //     itemBuilder: (ctx, index) {
        //       // return Card(
        //       //   child: Row(
        //       //     children: <Widget>[
        //       //       Container(
        //       //         margin: EdgeInsets.symmetric(
        //       //           vertical: 10,
        //       //           horizontal: 15,
        //       //         ),
        //       //         decoration: BoxDecoration(
        //       //           border: Border.all(
        //       //             color: Theme.of(context).primaryColor,
        //       //             width: 2,
        //       //           ),
        //       //         ),
        //       //         padding: EdgeInsets.all(10),
        //       //         child: Text(
        //       //           // tx.amount.toString(),
        //       //           '\$${transactions[index].amount.toStringAsFixed(2)}',
        //       //           style: TextStyle(
        //       //             fontWeight: FontWeight.bold,
        //       //             fontSize: 20,
        //       //             color: Theme.of(context).primaryColor,
        //       //           ),
        //       //         ),
        //       //       ),
        //       //       Column(
        //       //         crossAxisAlignment: CrossAxisAlignment.start,
        //       //         children: <Widget>[
        //       //           Text(
        //       //             transactions[index].title,
        //       //             style: Theme.of(context).textTheme.title,
        //       //             // style: TextStyle(
        //       //             //   fontSize: 16,
        //       //             //   fontWeight: FontWeight.bold,
        //       //             // ),
        //       //           ),
        //       //           Text(
        //       //             // tx.date.toString(),
        //       //             // DateFormat('yyyy/MM/dd').format(tx.date),
        //       //             DateFormat.yMMMd().format(transactions[index].date),
        //       //             style: TextStyle(
        //       //               color: Colors.grey,
        //       //             ),
        //       //           ),
        //       //         ],
        //       //       )
        //       //     ],
        //       //   ),
        //       // );
        //       return TransactionItem(
        //         transaction: transactions[index],
        //         deleteTx: deleteTx,
        //       );
        //     },
        //     itemCount: transactions.length,
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      transaction: tx,
                      deleteTx: deleteTx,
                    ))
                .toList()

            // children: transactions.map((tx) {
            //   // return Card(
            //   //   child: Row(
            //   //     children: <Widget>[
            //   //       Container(
            //   //         margin: EdgeInsets.symmetric(
            //   //           vertical: 10,
            //   //           horizontal: 15,
            //   //         ),
            //   //         decoration: BoxDecoration(
            //   //           border: Border.all(
            //   //             color: Colors.purple,
            //   //             width: 2,
            //   //           ),
            //   //         ),
            //   //         padding: EdgeInsets.all(10),
            //   //         child: Text(
            //   //           // tx.amount.toString(),
            //   //           '\$${tx.amount}',
            //   //           style: TextStyle(
            //   //             fontWeight: FontWeight.bold,
            //   //             fontSize: 20,
            //   //             color: Colors.purple,
            //   //           ),
            //   //         ),
            //   //       ),
            //   //       Column(
            //   //         crossAxisAlignment: CrossAxisAlignment.start,
            //   //         children: <Widget>[
            //   //           Text(
            //   //             tx.title,
            //   //             style: TextStyle(
            //   //               fontSize: 16,
            //   //               fontWeight: FontWeight.bold,
            //   //             ),
            //   //           ),
            //   //           Text(
            //   //             // tx.date.toString(),
            //   //             // DateFormat('yyyy/MM/dd').format(tx.date),
            //   //             DateFormat.yMMMd().format(tx.date),
            //   //             style: TextStyle(
            //   //               color: Colors.grey,
            //   //             ),
            //   //           ),
            //   //         ],
            //   //       )
            //   //     ],
            //   //   ),
            //   // );
            // }).toList(),
            );
  }
}

// class TransactionItem extends StatelessWidget {
//   const TransactionItem({
//     Key key,
//     @required this.transactions,
//     @required this.deleteTx,
//   }) : super(key: key);

//   final List<Transaction> transactions;
//   final Function deleteTx;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5,
//       margin: EdgeInsets.symmetric(
//         vertical: 8,
//         horizontal: 5,
//       ),
//       child: ListTile(
//         leading: CircleAvatar(
//           radius: 30,
//           child: Padding(
//             padding:const EdgeInsets.all(6),
//             child: FittedBox(
//               child: Text('\$${transactions[index].amount}'),
//             ),
//           ),
//         ),
//         title: Text(
//           transactions[index].title,
//           style: Theme.of(context).textTheme.title,
//         ),
//         subtitle: Text(
//           DateFormat.yMMMd().format(transactions[index].date),
//         ),
//         trailing: MediaQuery.of(context).size.width > 360
//             ? FlatButton.icon(
//               icon: const Icon(Icons.delete),
//               label: const Text('Delete'),
//                 textColor: Theme.of(context).errorColor,
//                 onPressed: () => deleteTx(transactions[index].id),
//               )
//             : IconButton(
//                 icon: const Icon(Icons.delete),
//                 color: Theme.of(context).errorColor,
//                 onPressed: () => deleteTx(transactions[index].id),
//               ),
//       ),
//     );
//   }
// }
