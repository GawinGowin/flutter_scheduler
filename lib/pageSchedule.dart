import 'package:flutter/material.dart';

import 'dart:convert';
import "dart:io";
import 'dart:ui' as ui;

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

Future<String> loadApiKey() async {
  final config = await rootBundle.loadString('lib/config.yaml');
  final yaml = loadYaml(config);
  return yaml['api_key'];
}

class Schedule extends StatefulWidget {
  const Schedule({super.key});
  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  bool isError = false;
  int time = DateTime.now().microsecondsSinceEpoch;

  final _controller = TextEditingController();

  final String host = "maps.googleapis.com";
  final String path = '/maps/api/directions/json';    

  bool arrivalOrDeparture = true; // {"arrival_time":true, "departure_time":false}
  int arrival_time = DateTime.now().microsecondsSinceEpoch;
  int departure_time = DateTime.now().microsecondsSinceEpoch;
  String log = "";

  Map results = {};

  //Map<String,String> msgs = {"head1":"", "head2":""};

  Future<void> getData() async{
    final apiKey = await loadApiKey();

    Map <String, String> params = {
      "destination": "place_id:ChIJd7mELCywEmsR0Ajw-Wh9AQ8", // ロイヤル・プリンス・アルフレッド病院
      "origin":"place_id:ChIJlwsH0RWuEmsR3Cg3WEDw76I", // オーストラリア博物館
      "mode": "DRIVING", // available_travel_modes = ["DRIVING", "WALKING", "BICYCLING"]
      "language": "ja",
      "key": apiKey};

    if (arrivalOrDeparture){
      params["arrival_time"] = "$arrival_time";
    }
    else {
      params["departure_time"] = "$departure_time";
    }

    try {
      var response = await http.get(
        Uri.https(host, path, params));

      var jsonResponse = errorMsgs(response);
      setState(() {
        _controller.text = jsonResponse['routes'].join();
        results = analyseRequest(jsonResponse);
      });
    } on SocketException catch (socketException) {
      // ソケット操作が失敗した時にスローされる例外
      debugPrint("Error: ${socketException.toString()}");
      isError = true;
      log = "SocketException";
      
    } on Exception catch (exception) {
      // statusCode: 200以外の場合
      debugPrint("Error: ${exception.toString()}");
      isError = true;
      log = "Error: ${exception.toString()}";
 
    } catch (_) {
      debugPrint("Error: 何かしらの問題が発生しています");
      isError = true;
      log = "unexpected Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("予定"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /**
             * Padding(
             * padding: EdgeInsets.all(8),
             * child:Text(_controller.text)
             * ),
             */
            Padding(
              padding: EdgeInsets.all(8),
              child:Text(jsonEncode(results))
            ),

            SwitchListTile(
              title: const Text('到着時刻 <----> 出発時刻'),
              value: arrivalOrDeparture,
              onChanged: (bool value){setState(() {arrivalOrDeparture = value; print("arrivalOrDeparture: $arrivalOrDeparture");});},
              secondary: const Icon(Icons.lightbulb_outline),
            )
          ],
        )
      ),
      
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.open_in_new),
        onPressed: () {
          getData();
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text("loaded!"),
                content: Text("なんかメッセージ"),
              )
          );
        },
      ),
    );
  }
}

Map<String, dynamic> analyseRequest(Map jsonResponse){
  Map<String, dynamic> resultMap = {
    "start_address" : jsonResponse["routes"][0]["legs"][0]["start_address"],
    "end_address" : jsonResponse["routes"][0]["legs"][0]["end_address"], 
    "distance": jsonResponse["routes"][0]["legs"][0]["distance"]["value"],
    "duration": jsonResponse["routes"][0]["legs"][0]["duration"]["value"],
    "copyrights" : jsonResponse["routes"][0]["copyrights"],
  };
  return resultMap;
}

dynamic errorMsgs(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = jsonDecode(response.body);
      return responseJson;
    case 400:
      throw Exception('一般的なクライアントエラーです');
    case 401:
      throw Exception('アクセス権限がない、または認証に失敗しました');
    case 403:
      throw Exception('閲覧権限がないファイルやフォルダです');
    case 404:
      throw Exception('404 Not Found');
    case 500: 
      throw Exception('何らかのサーバー内で起きたエラーです');
    default:
      throw Exception('何かしらの問題が発生しています');
  }
}

/*
Getメソッドを用いたリクエストの実装について
https://zenn.dev/mukkun69n/articles/c9980d3298cf9e
*/