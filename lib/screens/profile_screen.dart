// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _controller = TextEditingController();

  Future<void> _updateUserName() async {
    if (_controller.text.isEmpty) return;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({"userName": _controller.text});
      FocusScope.of(context).requestFocus(FocusNode());
      _controller.text = "";
    } catch (err) {
      print(err);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final userData = snapshot.data;
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              userData.data().containsKey("userName")
                  ? Center(
                      child: Text("ユーザ名：${userData.get('userName')}"),
                    )
                  : Center(
                      child: Text("ユーザ名が設定されていません"),
                    ),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: "ユーザ名"),
                ),
              ),
              RaisedButton(
                child: Text("ユーザ名を設定"),
                onPressed: _updateUserName,
              ),
            ],
          ),
        );
      },
    );
  }
}
