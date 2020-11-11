// screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../screens/setting_screen.dart';
import '../widgets/home/show_email.dart';
import '../screens/add_todo_screen.dart';
import '../widgets/UI/show_modal_button.dart';
import '../screens/todo_overview_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/home/user_list.dart';

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
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    // 通知を許可するようリクエスト
    fbm.requestNotificationPermissions();
    // 設定を行う
    fbm.configure(
      onMessage: (msg) {
        print(msg);
        return;
      },
      onLaunch: (msg) {
        print(msg);
        return;
      },
      onResume: (msg) {
        print(msg);
        return;
      },
    );
    // トピックをユーザIDに設定する
    fbm.subscribeToTopic(FirebaseAuth.instance.currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // 追加
          leading: ShowModalButton(
            Icon(
              Icons.add,
            ),
            AddTodoScreen(),
          ),
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
        body: _currentPage == 0
            ? Column(
                children: [
                  ShowEmail(),
                  Container(
                    height: 300,
                    child: UserList(),
                  ),
                ],
              )
            : _currentPage == 1
                ? TodoOverviewScreen()
                : _currentPage == 2
                    ? SettingScreen()
                    : ProfileScreen(),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.home, title: "ホーム"),
            TabData(iconData: Icons.list, title: "TODOリスト"),
            TabData(iconData: Icons.settings, title: "設定"),
            TabData(iconData: Icons.account_circle, title: "プロフィール")
          ],
          onTabChangedListener: (position) {
            setState(() {
              _currentPage = position;
            });
          },
        ));
  }
}
