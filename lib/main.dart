import 'package:chat_app_vish/screens/new_grievance_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_vish/screens/welcome_screen.dart';
import 'package:chat_app_vish/screens/login_screen.dart';
import 'package:chat_app_vish/screens/registration_screen.dart';
import 'package:chat_app_vish/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app_vish/screens/greivance.dart';
import 'package:chat_app_vish/screens/new_grievance_screen.dart';
import 'package:chat_app_vish/screens/admin_screen.dart';
import 'package:chat_app_vish/screens/solved_screen.dart';

void main() async{

  // Ensure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized(); //firebase
  // Initialize Firebase
  await Firebase.initializeApp(); //firebase
  //
  runApp(FlashChat()); //firebase
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),*/
      theme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.white.withOpacity(0.4)),
      ),
      home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        SolvedScreen.id: (context) => SolvedScreen(),
        AdminScreen.id: (context) => AdminScreen(),
        NewGrievance.id: (context) => NewGrievance(),
        GrievanceScreen.id: (context) => GrievanceScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
