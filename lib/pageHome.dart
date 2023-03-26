import 'package:flutter/material.dart';

import "package:shared_preferences/shared_preferences.dart";

import 'package:flutter_scheduler/modules/clock_card.dart';
import 'package:flutter_scheduler/modules/item_card.dart';

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
  String _mode = "walking";

  List<String> _texts = [];

  @override
  void initState() {
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
            itemCard(
              _texts,
              deviceWidth,
              deviceHeight
            ),
          ]
        )),
    );
  }  
  Future<void> loadPref() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // clock card contexts
      _arrivalTime = (prefs.getInt("arrivalTime") ?? DateTime.now().microsecondsSinceEpoch);
      _departureTime = (prefs.getInt("departureTime") ?? DateTime.now().microsecondsSinceEpoch);
      _duration = (prefs.getInt("duration") ?? 0);
      _arrivalOrDeparture = (prefs.getBool("arrivalOrDeparture") ?? true);
      _mode = (prefs.getString("mode") ?? "walking"); //["walking", "bicycling", "driving"]
      // item list contexts
      _texts = (prefs.getStringList("texts") ?? []);
    });
    printLog();
  }
  void printLog(){
    print("-"*35);
    print("arrivalTime: $_arrivalTime");
    print("departureTime: $_departureTime");
    print("duration: $_duration (${_duration/1000000~/60} min)");
    print("arrivalOrDeparture: $_arrivalOrDeparture");
    print("$_departureTime to $_arrivalTime:${_arrivalTime-_departureTime}");
    print("mode: $_mode");
  }
}
