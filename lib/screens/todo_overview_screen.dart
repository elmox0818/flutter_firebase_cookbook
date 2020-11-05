// lib/screens/todo_overview_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/todo/delete_todo_button.dart';
import '../widgets/todo/todo_checkbox.dart';
// 追加
import '../widgets/todo/todo_good_button.dart';

class TodoOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("todos")
          .orderBy("createdAt", descending: true)
          .where("isDone", isEqualTo: false)
          .snapshots(),
      builder: (ctx, snapshots) {
        // 読み込み中
        if (snapshots.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        // データ取得に失敗
        if (!snapshots.hasData) {
          return Center(
            child: Text("no data"),
          );
        }
        final todoDocs = snapshots.data.docs;
        return ListView.builder(
          itemCount: todoDocs.length,
          itemBuilder: (cx, index) {
            return Card(
              child: ListTile(
                leading: TodoCheckBox(todoDocs[index].id),
                title: Text(
                  todoDocs[index].get("body"),
                ),
                subtitle: Text(
                  DateFormat("yyyy/MM/dd HH:mm")
                      .format(
                        todoDocs[index].get("createdAt").toDate(),
                      )
                      .toString(),
                ),
                // 変更
                trailing: Container(
                  width: 150,
                  child: Row(
                    children: [
                      DeleteTodoButton(todoDocs[index].id),
                      TodoGoodButton(todoDocs[index].id),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
