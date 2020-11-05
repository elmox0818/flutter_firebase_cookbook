// lib/widgets/todo/delete_todo_button.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../helpers/alert_helpers.dart';

class DeleteTodoButton extends StatelessWidget {
  DeleteTodoButton(this.todoID);
  final String todoID;

  final AlertHelpers alert = AlertHelpers();

  void _deleteCheck(BuildContext context) {
    alert.showWarningDialog(context, "確認", "TODOを削除してよろしいですか？", _deleteTODO);
  }

  Future<void> _deleteTODO() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("todos")
          .doc(todoID)
          .delete();
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () {
          _deleteCheck(context);
        });
  }
}
