import 'package:flutter/material.dart';

// class Schedule extends StatelessWidget {
//   const Schedule({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("予定"),
//       ),
//     );
//   }
// }

class Schedule extends StatefulWidget {
  Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  TimeOfDay? selectedTime;
  MaterialColor selectedColor = Colors.orange;
  MaterialColor notSelectedColor = Colors.blue;
  MaterialColor depPrimaryColor = Colors.blue;
  MaterialColor arrPrimaryColor = Colors.blue;

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
        ],
      ),
    );
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
