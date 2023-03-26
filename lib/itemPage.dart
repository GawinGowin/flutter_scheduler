import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";


class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  List<String> _texts = [];
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  void _addTextToList() async{
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        _texts.add(_textEditingController.text);
        _textEditingController.clear();
        savePref();
      });
    }
  }

  void _removeTextFromList(int index) async{
    setState(() {
      _texts.removeAt(index);
      savePref();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.add_circle_outline, color: Colors.grey,),
        title: Text("追加", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.grey[200]
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(deviceWidth*0.05),
            child:TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'メモを入力',
            ),
          ),),

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

  void loadPref() async{
    final prefs = await SharedPreferences.getInstance();
    setState((){
      _texts = (prefs.getStringList("texts") ?? []);
    });
  }

  void savePref() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("texts", _texts);
  }
}
