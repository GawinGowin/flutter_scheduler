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
  DateTime now = DateTime.utc(1989, 11, 9);
  DateTime arrive = DateTime.utc(1989, 11, 10);
  final _controller = TextEditingController();

  Future<void> getData() async{
    const host = "maps.googleapis.com";
    const path = '/maps/api/directions/json';    
    final apiKey = await loadApiKey();

    final params = {
      "destination": "Montreal",
      "origin":"Toronto",
      "key": apiKey};

    try {
      var response = await http.get(
        Uri.https(
          host,
          path,
          params
        ));

      var jsonResponse = errorMsgs(response);
      setState(() {
        _controller.text = jsonResponse['routes'].join();
      });
    } on SocketException catch (socketException) {
      // ソケット操作が失敗した時にスローされる例外
      debugPrint("Error: ${socketException.toString()}");
      isError = true;
    } on Exception catch (exception) {
      // statusCode: 200以外の場合
      debugPrint("Error: ${exception.toString()}");
      isError = true;
    } catch (_) {
      debugPrint("Error: 何かしらの問題が発生しています");
      isError = true;
    }
  }

  dynamic errorMsgs(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        // 400 Bad Request : 一般的なクライアントエラー
        throw Exception('一般的なクライアントエラーです');
      case 401:
        // 401 Unauthorized : アクセス権がない、または認証に失敗
        throw Exception('アクセス権限がない、または認証に失敗しました');
      case 403:
        // 403 Forbidden ： 閲覧権限がないファイルやフォルダ
        throw Exception('閲覧権限がないファイルやフォルダです');
      case 404:
        // Not Found ： クライアントの要求に該当するものをサーバが見つけられなかった
        throw Exception('Not Found');
      case 500: 
        // 500 何らかのサーバー内で起きたエラー
        throw Exception('何らかのサーバー内で起きたエラーです');
      default:
        // それ以外の場合
        throw Exception('何かしらの問題が発生しています');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("予定"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text('INTERNET ACCESS.',
              style: TextStyle(fontSize: 24,
                  fontWeight: ui.FontWeight.w500),
            ),
            Padding(padding: EdgeInsets.all(10.0)),

            Flexible(child: Text(_controller.text)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.open_in_new),
        onPressed: () {
          getData();
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text("loaded!"),
                content: Text("get content from URI."),
              )
          );
        },
      ),
    );
  }
}

/*
Getメソッドを用いたリクエストの実装について
https://zenn.dev/mukkun69n/articles/c9980d3298cf9e
*/