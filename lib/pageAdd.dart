import 'package:flutter/material.dart';

class Add extends StatelessWidget {
  const Add({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.add_circle_outline, color: Colors.grey,),
        title: Text("追加", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.grey[200]
      ),
    );
  }
}