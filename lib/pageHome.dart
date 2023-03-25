import 'package:flutter/material.dart';

import 'package:flutter_scheduler/modules/clock_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;

  DateTime arrivalTime = DateTime.now();
  DateTime departureTime = DateTime.now().add(const Duration(hours: 2));

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home, color: Colors.grey,),
        title: const Text("ホーム", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.grey[200]
      ),

      body: Container(
        child: Column(
          children: <Widget>[
            clockCard(arrivalTime, departureTime, deviceWidth, deviceHeight),

          ]
        )),
      
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
