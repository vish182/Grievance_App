import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kInputFieldStyling =  InputDecoration(
  hintText: 'Enter value',
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kSenderBubbleRadius = BorderRadius.only(
  topLeft: Radius.circular(20.0),
  bottomLeft: Radius.circular(20.0),
  bottomRight: Radius.circular(20.0),
);

const kUserBubbleRadius = BorderRadius.only(
  topRight: Radius.circular(20.0),
  bottomLeft: Radius.circular(20.0),
  bottomRight: Radius.circular(20.0),
);

const int kGameZone = 1;
const int kWallStreet= 2;
const int kCompCode = 3;


const kEvents = {'CodeStrike': 1, 'NinjaCoding': 2,  'DesignMaestro': 3,  'DataCup': 4, 'MineCraftBuildBattles': 5, 'AutomationBots': 6, 'CircuitCreation': 7, 'ProjectPresentation': 8, 'GameZone': 9};

const kGetEvent = {1: 'CodeStrike', 2:'NinjaCoding',  3: 'DesignMaestro', 4: 'DataCup', 5: 'MineCraftBuildBattles', 6: 'AutomationBots', 7: 'CircuitCreation', 8: 'ProjectPresentation', 9: 'GameZone'};

