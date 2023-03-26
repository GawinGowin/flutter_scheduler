import 'package:flutter/material.dart';

Container itemCard(
  List<String> items, double deviceWidth, double deviceHeight){
  return Container(
    height: deviceHeight*0.35,
    width: double.infinity,
    margin: const EdgeInsets.all(20),
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),

    child: ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 5),
          child:  Container(
            child: Row(
              children: [
                Container(
                  width: deviceWidth*0.15,
                  alignment: Alignment.center,
                  child: Icon((Icons.favorite),)
                ),
                Container(
                  width: deviceWidth*0.7,
                  alignment: Alignment.centerLeft,
                  child: Text('${items[index]}', style: TextStyle(fontSize: 20),)
                )
              ],
            ),
          ),
          
        );
      }
    ),


  );
}