import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;
  DateTime time = DateTime.now();
  
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home, color: Colors.grey,),
        title: Text("ホーム", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.grey[200]
      ),

      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: deviceHeight*0.25,
              width: double.infinity,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(5),
              color: Colors.green,

              child: Column(
                children: [
                  Container(
                    child: Text(
                      "${time.year}-${time.month}-${time.day}",
                      style: TextStyle(fontSize: 32,),
                    ),
                    height: 32,
                    color: Colors.green[700],
                    alignment: Alignment.topLeft,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        color: Colors.red,
                        width: deviceWidth*0.55,
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                "${time.hour}:${time.minute}:${time.second}",
                                style: TextStyle(fontSize: 40),
                              ),
                              height: 40,
                              color: Colors.blue,
                            ),
                      
                            Container(
                              child: Text(
                                String.fromCharCodes([0x22EE]),
                                style: TextStyle(fontSize: 40),
                              ),
                              height: 50,
                              color: Colors.blue,
                            ),
                      
                            Container(
                              child: Text(
                                "${time.hour}:${time.minute}:${time.second}",
                                style: TextStyle(fontSize: 40),
                              ),
                              height: 40,
                              color: Colors.blue,
                            ),                        
                          ],
                        ),
                      ),                        
                    ],
                  ),
                  Container(
                    width: deviceWidth*0.40,
                    color: Colors.red[100],
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            "出発",
                            style: TextStyle(fontSize: 30),
                          ),
                          height: 30,
                          color: Colors.blue,
                        ),

                        Container(
                          child: Text(
                            "到着",
                            style: TextStyle(fontSize: 30),
                          ),
                          height: 30,
                          color: Colors.blue,
                        ),                        
                      ],
                    ),
                  ),                        
                ],
              )
            ),

            
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
