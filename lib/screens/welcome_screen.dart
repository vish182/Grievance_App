import 'package:chat_app_vish/screens/greivance.dart';
import 'package:chat_app_vish/screens/login_screen.dart';
import 'package:chat_app_vish/screens/new_grievance_screen.dart';
import 'package:chat_app_vish/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app_vish/Components/rounded_button.dart';
import 'package:chat_app_vish/screens/admin_screen.dart';
import 'package:chat_app_vish/constants.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      //upperBound: 100
    );

    controller.forward();
    //controller.reverse(from: 1);
    animation = ColorTween(begin: Colors.blue, end: Colors.red).animate(controller);

    controller.addListener(() {
      setState(() {

      });
      //print(controller.value);
      print(animation.value);
    });

  }


  @override
  void dispose() {
    print('dispose');
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //controller.forward();
    return Scaffold(
      //backgroundColor: Colors.red,//.withOpacity(controller.value),
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // ignore this row widget
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: controller.value*60,
                  ),
                ),

                TypewriterAnimatedTextKit(
                  text: ['PCSB'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),

              ],
            ),
            SizedBox(
              height: 48.0,
            ),

            /*
           * This button will take you to user's grievance page (grievance.dart),
           * you have to provide the event according to what event's grievance button was clicked
           * this button is the route, place it appropriately beside each event with respective eventID
           */
           RoundedButton( // Components/RoundedButton.dart
              color: Colors.blueAccent,
              title: 'Grievance for an Event',
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => GrievanceScreen(eventID: kEvents['DataCup'],))); // grievance for event DataCup,
                                                                                                      // replace with DataCup respective ents from kEvents from constants.dart

              },
            ),


           /*
           * This button will take you to admin page (admin_screen.dart),
           *  you have to provide the event for the respective admin at login
           */
           RoundedButton(
              color: Colors.blueAccent,
              title: 'Admin',
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminScreen(eventID: kEvents['DataCup'],))); // for example this admin is handling data cup grievances
                                                                                                                              // find kEvents map in constants.dart
              },
            ),

          ],
        ),
      ),
    );
  }
}






/* Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                    //Go to login screen.
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Log In',
                  ),
                ),
              ),
            ),*/
/* Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                    //Go to registration screen.
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                  ),
                ),
              ),
            ),*/