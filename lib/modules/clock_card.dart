import 'package:flutter/material.dart';

Container clockCard(
  DateTime arrivalTime, DateTime departureTime, double deviceWidth, double deviceHeight){
  return Container(
    height: deviceHeight*0.28,
    width: double.infinity,
    margin: const EdgeInsets.all(20),
    padding: const EdgeInsets.all(5),
    //color: Colors.green,
    child: Column(
      children: [
        Container(
          height: 30,
          alignment: Alignment.topLeft,
          //color: Colors.green[700],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text(
                "${arrivalTime.year.toString().padLeft(2, "0")}-${arrivalTime.month.toString().padLeft(2, "0")}-${arrivalTime.day.toString().padLeft(2, "0")}",
                style: const TextStyle(fontSize: 28),
              ),
              const Icon(Icons.double_arrow),
              Text(
                "${departureTime.year.toString().padLeft(2, "0")}-${departureTime.month.toString().padLeft(2, "0")}-${departureTime.day.toString().padLeft(2, "0")}",
                style: const TextStyle(fontSize: 28),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical:10),
              //color: Colors.red,
              width: deviceWidth*0.55,
              child: Column(
                children: [
                  Container(
                    //color: Colors.blue,
                    height: 55,
                    child: Text(
                      "${arrivalTime.hour.toString().padLeft(2, "0")}:${arrivalTime.minute.toString().padLeft(2, "0")}",
                      style: const TextStyle(fontSize: 55),
                    ),
                  ),
            
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    //color: Colors.blue,
                    child: Text(
                      String.fromCharCodes([0x22EE]),
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),

                  Container(
                    height: 55,
                    //color: Colors.blue,                              
                    child: Text(
                      "${departureTime.hour.toString().padLeft(2, "0")}:${departureTime.minute.toString().padLeft(2, "0")}",
                      style: const TextStyle(fontSize: 55),
                    ),
                  ),                        
                ],
              ),
            ),  

          Container(
            margin: const EdgeInsets.symmetric(vertical:10),
            width: deviceWidth*0.30,
            //color: Colors.red[100],
            child: Column(
              children: [
                Container(
                  height: 55,
                  alignment: Alignment.centerLeft,
                  //color: Colors.blue,
                  child: const Text(
                    "出発",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Container(height: 50),
                Container(
                  height: 55,
                  alignment: Alignment.centerLeft,
                  //color: Colors.blue,
                  child: const Text(
                    "到着",
                    style: TextStyle(fontSize: 30),
                  ),
                ),                        
              ],
            ),
          ),   
          ],
        ),
      ],
    )
  );
}