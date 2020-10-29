// screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

import '../screens/setting_screen.dart';
import '../widgets/home/show_email.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 0;

  Future<void> _signOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            FlatButton(
              onPressed: _signOut,
              child: Text(
                "サインアウト",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: _currentPage == 0 ? ShowEmail() : SettingScreen(),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.home, title: "ホーム"),
            TabData(iconData: Icons.settings, title: "設定")
          ],
          onTabChangedListener: (position) {
            setState(() {
              _currentPage = position;
            });
          },
        ));
  }
}
