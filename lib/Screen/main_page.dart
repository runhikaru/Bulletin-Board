import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bulletin_board/Screen/Notifier/notifier_page.dart';
import 'package:flutter_bulletin_board/Screen/Thread/thread_page.dart';
import 'package:flutter_bulletin_board/api/ip_info_api.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(child: Text("モンスターグロー")),
          ListTile(
            title: Text("お知らせ"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotifierPage()));
            },
          )
        ]),
      ),
      body: ListTile(
          title: Text("スレッド"),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ThreadPage()));
          }),
    );
  }
}
