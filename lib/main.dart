// lib/main.dart

import 'package:flutter/material.dart';
// 追加部分
import 'package:firebase_core/firebase_core.dart';

// 追加部分
import 'widgets/auth/auth_check.dart';

// 編集部分
void main() async {
  // これがないとエラーが出ます
  WidgetsFlutterBinding.ensureInitialized();
  // Firebaseのサービスを使う前に初期化を行います
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
      // 編集部分
      home: AuthCheck(),
    );
  }
}
