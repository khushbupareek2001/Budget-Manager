import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Reminder extends StatefulWidget {
  // const Reminder({ Key? key }) : super(key: key);
  static final now = DateTime.now();

  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  TextEditingController dateController = TextEditingController();
  TextEditingController title = TextEditingController();

  String dob = "";

  TextEditingController timeController = TextEditingController();

  String time = "";

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
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: dateTimeUi(),
            ),
          ),
        ],
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
