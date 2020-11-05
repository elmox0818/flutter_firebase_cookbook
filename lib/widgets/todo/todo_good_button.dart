// lib/widgets/todo/todo_good_button.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoGoodButton extends StatelessWidget {
  TodoGoodButton(this.todoID);
  final String todoID;

  Future<void> _sendGood() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("todos")
        .doc(todoID)
        .update({
      "goodCounter": FieldValue.increment(1),
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
          return FlatButton.icon(
            onPressed: _sendGood,
            icon: Icon(
              Icons.favorite,
              color: Colors.pink,
            ),
            // フィールドがあるか確認
            label: todoDoc.data().containsKey("goodCounter")
                ? Text(todoDoc.get("goodCounter").toString())
                : Text("0"),
          );
        });
  }
}
