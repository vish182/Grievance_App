import 'dart:developer';

import 'package:chat_app_vish/Components/rounded_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_vish/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //firebase
import 'package:chat_app_vish/screens/new_grievance_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'solved_screen.dart';

import 'dart:ui';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class AdminScreen extends StatefulWidget {
  static const String id = 'admin_screen';

  final int eventID;

  AdminScreen({this.eventID});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {

  }

  List<GrievanceBubbleAdmin> grievanceList = [];

  User loggedinUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/space1.jpg"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Answer These Questions',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 35,
                      ),
                    ),
                    RoundedButton(
                      color: Colors.black12.withOpacity(0.1),
                      title: 'Solved Grievances',
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SolvedScreen(eventID: widget.eventID,)));
                        print('refresh');
                      },
                    ),
                    SizedBox(
                      width: 200,
                      child: Divider(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),

                GrievanceStream(eventID: widget.eventID),
              ],
            )),
      ),
    );
  }
}



class GrievanceStream extends StatelessWidget {

  final int eventID;

  GrievanceStream({@required this.eventID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('grievances')
          .where('open', isEqualTo: true).where('eventid', isEqualTo: eventID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        {
          final grievances = snapshot.data.docs;
          List<GrievanceBubbleAdmin> grievanceBubbles = [];
          for (var grievance in grievances) {
            print('This da id:  ' + grievance.id);
            final documentid = grievance.id;
            final grievanceTitle = grievance.data()['title'];
            final grievanceSender = grievance.data()['sender'];
            final grievanceText = grievance.data()['question'];
            final grievanceAnswer = grievance.data()['answer'];
            final grievanceEvent = grievance.data()['eventid'];
            final grievanceState = grievance.data()['open'];

            print(grievanceSender);

            final grievanceBubble = GrievanceBubbleAdmin(
              title: grievanceTitle,
              text: grievanceText,
              sender: grievanceSender,
              eventid: grievanceEvent,
              open: grievanceState,
              answer: grievanceAnswer,
              doucumentid: documentid,
            );
            grievanceBubbles.add(grievanceBubble);
          }
          return Expanded(
            child: ListView(
              children: grievanceBubbles,
            ),
          );
        }

      },
    );
  }
}

void showModalQuestion(context, String title, String text, String docid) {
  String answerText;
  bool showSpinner = false;

  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3,
            sigmaY: 3,
          ),
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Container(
                decoration: new BoxDecoration(
                    //color: Colors.transparent,
                    color: Colors.transparent,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))),
                padding: EdgeInsets.all(8),
                height: 600,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: kSendButtonTextStyle.copyWith(color: Colors.black54, fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            //'beeeeeeeeeeeeeg beeeg text reeeeeeeee reeeeeeeeeeeee reeeeeeeeeeeee reeeeeeeee reeeeeeeeeeeee reeeeeeeeeeeee reeeeeeeeeee reeeeeeeeeeee reeeeeeee reeeeeeeee reeeeeeeeeeeee reeeeeeeeeeeee reeeeeeeeeee reeeeee reeeeeeeee reeeeeeeeeeeee reeeeeeeeeeeee reeeeeeeeeee reeeeee reeeeeeeee reeeeeeeeeeeee reeeeeeeeeeeee reeeeeeeeeee reeeeee',
                            text,
                            style: kSendButtonTextStyle.copyWith(
                                color: Colors.black54, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        // hack textfield height
                        padding: EdgeInsets.only(bottom: 40.0),
                        child: TextField(
                          onChanged: (value) {
                            answerText = value;
                          },
                          maxLines: 99,
                          decoration: kInputFieldStyling.copyWith(
                              hintText: 'Enter Answer'),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: RoundedButton(
                            color: Colors.black26,
                            title: 'Cancel',
                            onPressed: () {
                              Navigator.pop(context);
                              print('to type grievance screen');
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: RoundedButton(
                            color: Colors.cyanAccent.withOpacity(0.3),
                            title: 'Submit',
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              await _firestore
                                  .collection('grievances')
                                  .doc(docid)
                                  .update({
                                //'time': DateTime.now().millisecondsSinceEpoch,
                                'open': false,
                                'answer': answerText,
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
            );
          }),
        );
      });
}

class GrievanceBubbleAdmin extends StatelessWidget {
  GrievanceBubbleAdmin(
      {this.title,
      this.text,
      this.eventid,
      this.open,
      this.sender,
      this.answer,
      this.doucumentid});
  final String title, sender, text, answer;
  final int eventid;
  final bool open;
  final String doucumentid;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showModalQuestion(context, title, text, doucumentid);
        print('solving grievance');
      },
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          elevation: 2,
          color: Colors.black12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'by: '+ sender,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,

                    ),
                    Text(
                      kGetEvent[eventid],
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: Divider(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black45, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
