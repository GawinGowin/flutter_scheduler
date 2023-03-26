import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _texts = [];
  TextEditingController _textEditingController = TextEditingController();

  void _addTextToList() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        _texts.add(_textEditingController.text);
        _textEditingController.clear();
      });
    }
  }

  void _removeTextFromList(int index) {
    setState(() {
      _texts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('持ち物'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _textEditingController,
          ),
          ElevatedButton(
            onPressed: _addTextToList,
            child: Text('追加'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _texts.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_texts[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeTextFromList(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
