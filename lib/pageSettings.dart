import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("設定", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.grey[200]
      ),
    );
  }
}