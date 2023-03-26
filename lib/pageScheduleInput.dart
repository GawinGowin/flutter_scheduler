import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import "dart:io";

import "package:shared_preferences/shared_preferences.dart";

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
// import 'package:flutter_InputScheduler/pageInputSchedule.dart';
// class InputSchedule extends StatelessWidget {
//   const InputSchedule({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("予定"),
//       ),
//     );
//   }
// }

class InputSchedule extends StatefulWidget {
  InputSchedule({Key? key}) : super(key: key);

  @override
  _InputScheduleState createState() => _InputScheduleState();
}

class _InputScheduleState extends State<InputSchedule> {
  TimeOfDay? selectedTime;
  MaterialColor selectedColor = Colors.orange;
  MaterialColor notSelectedColor = Colors.blue;
  MaterialColor depPrimaryColor = Colors.blue;
  MaterialColor arrPrimaryColor = Colors.blue;
  bool selectDep = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("時刻を入力"),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: this.depPrimaryColor),
                onPressed: () {
                  _pickTime(context);
                  setState(() {
                    this.depPrimaryColor = this.selectedColor;
                    this.arrPrimaryColor = this.notSelectedColor;
                    this.selectDep = true;
                  });
                },
                child: const Text("出発時間")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: this.arrPrimaryColor),
                onPressed: () {
                  _pickTime(context);
                  setState(() {
                    this.depPrimaryColor = this.notSelectedColor;
                    this.arrPrimaryColor = this.selectedColor;
                    this.selectDep = false;
                  });
                },
                child: const Text("到着時間")),
          ]),
          Text(selectedTime != null
              ? "${selectedTime!.hour}:${selectedTime!.minute}"
              : "Time"),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                // setState(() {
                //   if (selectedTime != null) {
                //     _saveTime("arrivalTime", selectedTime);
                //   }
                // });
                DateTime now = DateTime.now();
                DateTime _time = DateTime(now.year, now.month, now.day,
                    selectedTime!.hour, selectedTime!.minute);
                String select, notSelect;
                bool arrOrDep;
                if (selectDep == false) {
                  select = "arrivalTime";
                  notSelect = "departureTime";
                  arrOrDep = true;
                } else {
                  select = "departureTime";
                  notSelect = "arrivalTime";
                  arrOrDep = false;
                }
                _saveTime(select, _time);
                _saveTime(notSelect, now);
                _saveArrOrDep(arrOrDep);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (cntext) => Schedule(),
                    ));
              },
              child: Text("次に進む"))
        ],
      ),
    );
  }

  void _saveTime(String key, DateTime time) async {
    var prefs = await SharedPreferences.getInstance();
    int value = time.microsecondsSinceEpoch;
    prefs.setInt(key, value);
  }

  void _saveArrOrDep(bool arrOrDep) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("arrivalOrDeparture", arrOrDep);
  }

  Future _pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 10, minute: 0);

    final newTime =
        await showTimePicker(context: context, initialTime: initialTime);

    if (newTime != null) {
      setState(() => selectedTime = newTime);
    } else {
      return;
    }
  }
}

class Schedule extends StatefulWidget {
  const Schedule({super.key});
  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  int now = DateTime.now().microsecondsSinceEpoch;
  int _arrivalTime = 0;
  int _departureTime = 0;
  int _duration = 0;
  bool _arrivalOrDeparture =
      true; // {"arrivalTime":true, "departureTime":false}
  String _mode = "walking";

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  final _controller = TextEditingController();
  final String host = "maps.googleapis.com";
  final String path = '/maps/api/directions/json';

  String log = "";
  bool isError = false;
  Map results = {};

  List<String> modes = <String>["walking", "bicycling", "driving"];

  //Map<String,String> msgs = {"head1":"", "head2":""};

  Future<void> getData() async {
    final apiKey = await loadApiKey();
    Map<String, String> params = {
      "destination":
          "place_id:ChIJd7mELCywEmsR0Ajw-Wh9AQ8", // ロイヤル・プリンス・アルフレッド病院
      "origin": "place_id:ChIJlwsH0RWuEmsR3Cg3WEDw76I", // オーストラリア博物館
      "mode":
          _mode, // available_travel_modes = ["walking", "bicycling", "driving"]
      "language": "ja",
      "key": apiKey
    };

    try {
      var response = await http.get(Uri.https(host, path, params));

      var jsonResponse = errorMsgs(response);
      setState(() {
        _controller.text = jsonResponse['routes'].join();
        results = analyseRequest(jsonResponse);
        _duration = results["duration"] * 1000000;
        if (_arrivalOrDeparture) {
          _arrivalTime = now;
          _departureTime = now - _duration;
        } else {
          _arrivalTime = now + _duration;
          _departureTime = now;
        }
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
    List<bool> isSelected = <bool>[false, false, false];
    isSelected[modes.indexOf(_mode)] = true;

    return Scaffold(
      appBar: AppBar(
          leading: const Icon(
            Icons.schedule,
            color: Colors.grey,
          ),
          title: const Text(
            "予定",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.grey[200]),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text(jsonEncode(results))),
          SwitchListTile(
            title: const Text('到着時刻 <----> 出発時刻'),
            value: _arrivalOrDeparture,
            onChanged: (bool value) {
              setState(() {
                _arrivalOrDeparture = value;
                savePref();
              });
            },
            secondary: const Icon(Icons.lightbulb_outline),
          ),
          ToggleButtons(
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < isSelected.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    isSelected[buttonIndex] = true;
                  } else {
                    isSelected[buttonIndex] = false;
                  }
                }
                _mode = modes[isSelected.indexOf(true)];
                savePref();
              });
            },
            children: const <Widget>[
              Icon(Icons.directions_walk),
              Icon(Icons.directions_bike),
              Icon(Icons.drive_eta),
            ],
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.open_in_new),
        onPressed: () {
          getData();
          savePref();
        },
      ),
    );
  }

  void loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _arrivalTime = (prefs.getInt("arrivalTime") ??
          DateTime.now().microsecondsSinceEpoch);
      _departureTime = (prefs.getInt("departureTime") ??
          DateTime.now().microsecondsSinceEpoch);
      _duration = (prefs.getInt("duration") ?? 0);
      _arrivalOrDeparture = (prefs.getBool("arrivalOrDeparture") ?? true);
      _mode = (prefs.getString("mode") ??
          "walking"); //["walking", "bicycling", "driving"]
    });
  }

  void savePref() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("arrivalTime", _arrivalTime);
    prefs.setInt("departureTime", _departureTime);
    prefs.setInt("duration", _duration);
    prefs.setBool("arrivalOrDeparture", _arrivalOrDeparture);
    prefs.setString("mode", _mode);
    printLog();
  }

  void printLog() {
    print("arrivalTime: $_arrivalTime");
    print("departureTime: $_departureTime");
    print("duration: $_duration (${_duration / 1000000 ~/ 60} min)");
    print("arrivalOrDeparture: $_arrivalOrDeparture");
    print("$_departureTime to $_arrivalTime:${_arrivalTime - _departureTime}");
    print("mode: $_mode");
  }
}

Map<String, dynamic> analyseRequest(Map jsonResponse) {
  Map<String, dynamic> resultMap = {
    "start_address": jsonResponse["routes"][0]["legs"][0]["start_address"],
    "end_address": jsonResponse["routes"][0]["legs"][0]["end_address"],
    "distance": jsonResponse["routes"][0]["legs"][0]["distance"]["value"],
    "duration": jsonResponse["routes"][0]["legs"][0]["duration"]["value"],
    "copyrights": jsonResponse["routes"][0]["copyrights"],
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

Future<String> loadApiKey() async {
  final config = await rootBundle.loadString('lib/config.yaml');
  final yaml = loadYaml(config);
  return yaml['api_key'];
}

/*
# Refer
- https://zenn.dev/mukkun69n/articles/c9980d3298cf9e
*/
