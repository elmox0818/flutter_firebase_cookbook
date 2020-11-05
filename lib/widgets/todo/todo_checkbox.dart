import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoCheckBox extends StatelessWidget {
  TodoCheckBox(this.todoID);
  final String todoID;

  Future<void> _handleCheckBox(bool e) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("todos")
        .doc(todoID)
        .update({
      "isDone": e,
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection("todos")
            .doc(todoID)
            .get(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return Icon(Icons.error);
          }
          final todoDoc = snapshot.data;
          return Checkbox(
            value: todoDoc.get("isDone"),
            onChanged: _handleCheckBox,
          );
        });
  }
}
