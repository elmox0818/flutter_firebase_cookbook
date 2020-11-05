// lib/screens/add_todo_screen.dart

import 'package:flutter/material.dart';

import '../widgets/todo/add_todo_form.dart';

class AddTodoScreen extends StatelessWidget {
  static const routeName = "/add-todo";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: AddTodoForm(),
      ),
    );
  }
}
