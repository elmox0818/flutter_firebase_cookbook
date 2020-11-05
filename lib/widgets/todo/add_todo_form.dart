// libs/widgets/todo/add_todo_form.dart

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTodoForm extends StatefulWidget {
  @override
  _AddTodoFormState createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {
  final TextEditingController _controller = TextEditingController();
  String _todoValue = "";
  bool _isLoading = false;

  Future<void> _addTodo() async {
    if (_todoValue.isEmpty) return;
    try {
      setState(() {
        _isLoading = true;
      });
      // 現在サインインしているユーザを取得
      User user = FirebaseAuth.instance.currentUser;
      // ユーザのuidをidにしてドキュメントを追加
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("todos")
          .add({
        "uid": user.uid,
        "body": _todoValue,
        "createdAt": DateTime.now(),
        "isDone": false,
      });
      Navigator.pop(context);
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(labelText: "TODO"),
          onChanged: (value) => _todoValue = value,
        ),
        SizedBox(
          height: 12.0,
        ),
        _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RaisedButton(
                onPressed: _addTodo,
                child: Text("登録"),
              )
      ],
    );
  }
}
