import 'package:flutter/material.dart';
import 'package:flutter_notodo/ui/todo_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
        centerTitle: true,
        backgroundColor: Colors.black45,
      ),
      body: NoToDoScreen(),
    );
  }
}
