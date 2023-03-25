import 'package:flutter/material.dart';

class Add extends StatelessWidget {
  const Add({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("追加", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.grey[200]
      ),
    );
  }
}