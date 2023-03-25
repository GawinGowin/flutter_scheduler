import 'package:flutter/material.dart';

import "package:shared_preferences/shared_preferences.dart";

import 'package:flutter_scheduler/modules/clock_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _duration = 0;
  int _departureTime = DateTime.now().microsecondsSinceEpoch;
  int _arrivalTime = DateTime.now().microsecondsSinceEpoch;
  bool _arrivalOrDeparture = true; // {"arrivalTime":true, "departureTime":false}

  @override
  void initState(){
    super.initState();
    loadPref();
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
            clockCard(
              DateTime.fromMicrosecondsSinceEpoch(_arrivalTime),
              DateTime.fromMicrosecondsSinceEpoch(_departureTime),
              deviceWidth,
              deviceHeight),
          ]
        )),
    );
  }

  void loadPref() async{
    final prefs = await SharedPreferences.getInstance();
    setState((){
      _arrivalTime = (prefs.getInt("arrivalTime") ?? DateTime.now().microsecondsSinceEpoch);
      _departureTime = (prefs.getInt("departureTime") ?? DateTime.now().microsecondsSinceEpoch);
      _duration = (prefs.getInt("duration") ?? 0);
      _arrivalOrDeparture = (prefs.getBool("arrivalOrDeparture") ?? true);
    });
  }
}
