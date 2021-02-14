import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_vish/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //firebase

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textEditingController = TextEditingController();
  User loggedinUser;
  String messageText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
               // messageStream();
                //getMessages();
                _auth.signOut();
                //Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        messageText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textEditingController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedinUser.email,
                        'time': DateTime.now().millisecondsSinceEpoch,
                      });
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        print('not null');
        loggedinUser = user;
        print(loggedinUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void getMessages() async {
    final messages = await _firestore.collection('messages').get();

    print(messages);
    for (var message in messages.docs) {
      // "documents" deprecated to "docs"
      print(message.data());
      // above was print(message.data); BUT Getting a snapshots data via the data getter is now done via the data() method. per https://firebase.flutter.dev/docs/migration#firestore
    }
  }

  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        // "documents" deprecated to "docs"
        print(message.data());
        // above was print(message.data); BUT Getting a snapshots data via the data getter is now done via the data() method. per https://firebase.flutter.dev/docs/migration#firestore
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('time', descending: false)
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
          final messages = snapshot.data.docs;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data()['text'];
            final messageSender = message.data()['sender'];
            print("this");
            print(messageSender);
            print(_auth.currentUser.email);
            if (messageSender == _auth.currentUser.email) {
              final messageBubble = MessageBubble(
                messageSender: messageSender,
                messageText: messageText,
                side: CrossAxisAlignment.end,
              );
              messageBubbles.add(messageBubble);
            } else {
              final messageBubble = MessageBubble(
                messageSender: messageSender,
                messageText: messageText,
                side: CrossAxisAlignment.start,
              );
              messageBubbles.add(messageBubble);
            }
          }
          return Expanded(
            child: ListView(
              children: messageBubbles,
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

class MessageBubble extends StatelessWidget {
  MessageBubble({this.messageText, this.messageSender, this.side}){
    if(side == CrossAxisAlignment.start){
      borderRadius = kUserBubbleRadius;
      textColor = Colors.black54;
      bubbleColor = Colors.white;
    } else{
      borderRadius = kSenderBubbleRadius;
      textColor = Colors.white;
      bubbleColor = Colors.lightBlueAccent;
    }
  }
  BorderRadius borderRadius;
  Color textColor, bubbleColor;
  final String messageSender, messageText;
  final CrossAxisAlignment side;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: side,
        children: [
          Text(
            messageSender,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          Material(
            borderRadius: borderRadius,
            elevation: 5,
            color: bubbleColor,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                messageText,
                style: TextStyle(color: textColor, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
