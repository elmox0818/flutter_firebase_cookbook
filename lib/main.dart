// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './widgets/auth/auth_check.dart';
import './screens/password_change_screen.dart';
import './screens/email_change_screen.dart';
import './screens/reset_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase CookBook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthCheck(),
      routes: {
        PasswordChangeScreen.routeName: (context) => PasswordChangeScreen(),
        EmailChangeScreen.routeName: (context) => EmailChangeScreen(),
        ResetPasswordScreen.routeName: (context) => ResetPasswordScreen(),
      },
    );
  }
}
