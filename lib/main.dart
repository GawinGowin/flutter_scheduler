import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_scheduler/pageHome.dart';
import 'package:flutter_scheduler/pageSchedule.dart';
import 'package:flutter_scheduler/itemPage.dart';
import 'package:flutter_scheduler/pageSettings.dart';

void main() {
  const app = MaterialApp(home: MyApp());
  const scope = ProviderScope(child: app);
  runApp(scope);
}

final indexProvider = StateProvider((ref){
  return 0;
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);
    const items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label:"ホーム"
        ),
      BottomNavigationBarItem(
        icon: Icon(Icons.schedule),
        label:"予定"
        ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        label:"追加"
        ),        
      BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined),
        label:"設定"
        ),
    ];
    final bar = BottomNavigationBar(
      items: items,
      selectedItemColor: Colors.amber[600],
      unselectedItemColor: Colors.grey,
      currentIndex: index,
      onTap: (index){
        ref.read(indexProvider.notifier).state = index;
      },
    );

    final pages = [
      Home(),
      Schedule(),
      AddPage(),
      Settings(),
    ];
    
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: bar,
    );
  }
}