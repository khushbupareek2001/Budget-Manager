import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_budget/main.dart';
import 'package:personal_budget/models/web_response_extractor.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Reminder extends StatefulWidget {
  // const Reminder({ Key? key }) : super(key: key);
  static final now = DateTime.now();

  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  TextEditingController dateController = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController amount = TextEditingController();

  String dob = "";

  TextEditingController timeController = TextEditingController();
  FlutterLocalNotificationsPlugin fltrNotification;

  String time = "";
  @override
  void initState() {
    var androidInitilize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings = new InitializationSettings(
        android: androidInitilize, iOS: iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
    super.initState();
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);

    // await fltrNotification.show(
    //     0, "Task", "You created a Task", generalNotificationDetails,
    //     payload: "Task");
    var scheduledTime = DateTime.now().add(Duration(seconds: 5));
    fltrNotification.schedule(
        1,
        "Budget Manager",
        "Remainder: " + title.text.toString(),
        scheduledTime,
        generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminder"),
      ),
      body: Column(
        children: [
          Text("Set a reminder to pay your expenses at time"),
          Text(
            'Title',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextFormField(
              controller: title,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, top: 10.0),
                filled: true,
                fillColor: Colors.grey[50],
                focusColor: Colors.white70,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Amount',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextFormField(
              controller: amount,
              // textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, top: 10.0),
                filled: true,
                fillColor: Colors.grey[50],
                focusColor: Colors.white70,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: dateTimeUi(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reminder.length,
              itemBuilder: (ctx, i) => CartItem(
                reminder[i].time,
                reminder[i].title,
                reminder[i].amount,
                reminder[i].date,
                context,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget CartItem(
    final String time,
    final String title,
    final String amount,
    final String date,
    BuildContext context,
  ) {
    return Card(
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date; " + date),
              Text("Time: " + time),
            ],
          ),
          trailing: IconButton(
              onPressed: () {
                reminder.removeWhere((element) => (element.date == date &&
                    element.time == time &&
                    element.title == title &&
                    element.title == title));
                WebResponseExtractor.showToast("Deleted Successfully");
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              )),
          // trailing: Text('$date x'),
          // trailing: IconButton(
          //   onPressed: () {
          //     setState(() {
          //       personalTransactions.add(Transaction(
          //           id: id, title: title, amount: amount, date: date));
          //       familyMoney = familyMoney - amount;
          //       wishList.removeWhere((element) => element.id == id);
          //     });
          //     WebResponseExtractor.showToast(
          //         "Added to Transaction Successfully.");

          //     // Navigator.of(context).pop();
          //   },
          //   icon: Icon(
          //     Icons.done,
          //     color: Colors.green,
          //   ),
          // ),
        ),
      ),
    );
  }

  Widget dateTimeUi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          readOnly: true,
          controller: dateController,
          onTap: _presentDatePicker,
          decoration: InputDecoration(
            hintText: "Choose Date",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 1.5,
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        TextFormField(
          readOnly: true,
          controller: timeController,
          onTap: _presentTimePicker,
          decoration: InputDecoration(
            hintText: "Choose Time",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 1.5,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            RaisedButton(
              onPressed: () {
                _showNotification();
                reminder.add(Reminders(
                    title.text.toString(),
                    amount.text.toString(),
                    dateController.text.toString(),
                    timeController.text.toString()));
                WebResponseExtractor.showToast("Reminder added Successfully");
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        )
      ],
    );
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: Reminder.now,
      firstDate: Reminder.now,
      lastDate: DateTime(
          Reminder.now.year + 10, Reminder.now.month, Reminder.now.day),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        dateController.text = DateFormat('dd MMM yyyy').format(pickedDate);
        setState(() {
          // dob = DateFormat('yyyy-MM-dd').format(pickedDate);
          dob = dateController.text;
        });
      }
      print(dob);
    });
  }

  void _presentTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      } else
        timeController.text = DateFormat.jm().format(DateFormat("hh:mm")
            .parse("${pickedTime.hour}:${pickedTime.minute}"));
      setState(() {
        time = timeController.text;
      });
      print(time);
    });
  }
}
