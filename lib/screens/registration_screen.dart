import 'package:flutter/material.dart';
import 'package:chat_app_vish/constants.dart';
import 'package:chat_app_vish/Components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  bool showSpinner = false;
  final _auth = FirebaseAuth.instance; //firebase
  String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
                print(email);
                //Do something with the user input.
              },
              decoration: kInputFieldStyling.copyWith(hintText: 'Enter e-mail'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password = value;
                print(value);
                //Do something with the user input.
              },
              decoration: kInputFieldStyling.copyWith(hintText: 'Enter password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RoundedButton(
                color: Colors.blueAccent,
                title: 'Register',
                onPressed: () async {
                  print(email);
                  print(password);
                  setState(() {
                    showSpinner = true;
                  });
                  try{
                    final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password); //firebase

                    if(newUser != null){
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                  } catch(e){
                    setState(() {
                      showSpinner = false;
                    });
                    print(e);
                  }
                  //Go to registration screen.
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
