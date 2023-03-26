import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: Icon(
              Icons.settings_outlined,
              color: Colors.grey,
            ),
            title: Text(
              "設定",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.grey[200]),
        body: Text(
            'JDD | JP + UI Kit Android （© Japan Digital Designクリエイティブ・コモンズ・ライセンス（表示4.0 国際））を改変して作成 https://creativecommons.org/licenses/by/4.0/'));
  }
}
