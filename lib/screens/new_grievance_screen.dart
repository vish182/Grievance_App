import 'dart:ui';

import 'package:chat_app_vish/Components/rounded_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_vish/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //firebase
import 'package:chat_app_vish/constants.dart';
import 'package:chat_app_vish/screens/admin_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:ui';

final _firestore = FirebaseFirestore.instance;

class NewGrievance extends StatefulWidget {
  static const String id = 'new_grievance_screen';

  final int eventID;

  NewGrievance({this.eventID});

  @override
  _NewGrievanceState createState() => _NewGrievanceState();
}

class _NewGrievanceState extends State<NewGrievance> {

  String grievanceText;
  String grievanceTitle;
  final textEditingController = TextEditingController();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/space1.jpg"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'What is your grievance about?',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black12.withOpacity(0.3),
                        border: Border.all(
                          color: Colors.teal,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(32))
                    ),
                    child: TextField(
                      //controller: textEditingController,
                      keyboardType: TextInputType.multiline,
                      decoration: kInputFieldStyling.copyWith(hintText: 'Title'),
                      onChanged: (value) {
                        grievanceTitle = value;
                        print(value);
                        //Do something with the user input.
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Give us the details!',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black12.withOpacity(0.3),
                        border: Border.all(
                          color: Colors.teal,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(32))
                    ),
                    margin: EdgeInsets.all(8.0),
                    // hack textfield height
                    //padding: EdgeInsets.only(bottom: 0),
                    child: TextField(
                      //controller: textEditingController,
                      onChanged: (value) {
                        grievanceText = value;
                      },
                      maxLines: 99,
                      decoration:
                          kInputFieldStyling.copyWith(hintText: 'Enter details',),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: RoundedButton(
                        color: Colors.white.withOpacity(0.15),
                        title: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                          print('to type grievance screen');
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                    Flexible(
                      flex: 1,
                      child: RoundedButton(
                        color: Colors.cyanAccent.withOpacity(0.4),
                        title: 'Submit',
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          //textEditingController.clear();
                          await _firestore.collection('grievances').add({
                            'question': grievanceText,
                            'sender': 'dummy@123', // TODO: replace dummy@123 with users email
                            'title': grievanceTitle,
                            'open': true,
                            'eventid': widget.eventID,
                            'answer': 'null',
                          });

                          setState(() {
                            showSpinner = false;
                          });

                          Navigator.pop(context);

                          print('to type grievance screen');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


