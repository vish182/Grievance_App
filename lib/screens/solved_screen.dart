import 'dart:developer';

import 'package:chat_app_vish/Components/rounded_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_vish/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //firebase
import 'package:chat_app_vish/screens/new_grievance_screen.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:ui';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class SolvedScreen extends StatefulWidget {
  static const String id = 'solved_screen';

  final int eventID;

  SolvedScreen({this.eventID});

  @override
  _SolvedScreenState createState() => _SolvedScreenState();
}

class _SolvedScreenState extends State<SolvedScreen> {
  @override
  void initState() {

  }

  List<GrievanceBubble> grievanceList = [];

  User loggedinUser; // assign email id of user to this
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
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Solved Grievances',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 40,
                  ),
                ),

                SizedBox(
                  width: 200,
                  child: Divider(
                    color: Colors.black54,
                  ),
                ),
                GrievanceStreamSolved(eventID: widget.eventID,),
              ],
            )),
      ),
    );
  }
}
/*
Expanded(
child: ListView(
children: grievanceList,
),
)*/

class GrievanceStreamSolved extends StatelessWidget {
  bool showSpinner= false;

  final int eventID;

  GrievanceStreamSolved({@required this.eventID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('grievances').where('open', isEqualTo: false).where('eventid', isEqualTo: eventID)
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
          List<GrievanceBubble> grievanceBubbles = [];
          for (var grievance in grievances) {
            print('This da id:  ' + grievance.id);
            final grievanceTitle = grievance.data()['title'];
            final grievanceSender = grievance.data()['sender'];
            final grievanceText = grievance.data()['question'];
            final grievanceAnswer = grievance.data()['answer'];
            final grievanceEvent = grievance.data()['eventid'];
            final grievanceState = grievance.data()['open'];

            print(grievanceSender);


            final grievanceBubble = GrievanceBubble(
              title: grievanceTitle,
              text: grievanceText,
              sender: grievanceSender,
              eventid: grievanceEvent,
              open: grievanceState,
              answer: grievanceAnswer,
            );
            grievanceBubbles.add(grievanceBubble);

          }
          return Expanded(
            child: ListView(
              children: grievanceBubbles,
            ),
          );
        }

        return Column(
          children: [
            Text('Empty'),
          ],
        );
      },
    );
  }
}

class GrievanceBubble extends StatelessWidget {

  GrievanceBubble({this.title, this.text, this.eventid, this.open, this.sender, this.answer});
  final String title, sender, text, answer;
  final int eventid;
  final bool open;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showModalQuestion(context, title, text, answer);
      },
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          elevation: 2,
          color: Colors.black12.withOpacity(0.1),
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
                      'from: '+ sender,
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

void showModalQuestion(context, String title, String text, String answer) {
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: kSendButtonTextStyle.copyWith(color: Colors.black54),
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
                        style:
                        kSendButtonTextStyle.copyWith(color: Colors.black54),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Answer:',
                      style: kSendButtonTextStyle.copyWith(color: Colors.black54),
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
                        answer,
                        style:
                        kSendButtonTextStyle.copyWith(color: Colors.black54),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RoundedButton(
                    color: Colors.black26,
                    title: 'Back',
                    onPressed: () {
                      Navigator.pop(context);
                      print('to type grievance screen');
                    },
                  ),
                ),

              ],
            ),
          ),
        );
      });
}
