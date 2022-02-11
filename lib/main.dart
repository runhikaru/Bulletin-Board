import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bulletin_board/Screen/main_page.dart';
import 'package:flutter_bulletin_board/api/ip_info_api.dart';
import 'package:flutter_bulletin_board/utils/shard_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBWBKw_hAuStcHd9oOlgw_TbCXTPTPhFHY",
          authDomain: "keiziban919.firebaseapp.com",
          projectId: "keiziban919",
          storageBucket: "keiziban919.appspot.com",
          messagingSenderId: "816215712170",
          appId: "1:816215712170:web:c9372d0226ae6ff6208bd3",
          measurementId: "G-ND0BHRWKCN"),
    );
  } else {
    await Firebase.initializeApp();
  }
  await SharedPrefs.setInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> map = {};

  @override
  void initState() {
    super.initState();
    checkerAccount();
  }

  Future<void> checkerAccount() async {
    String uid = SharedPrefs.getUid();

    if (uid == '') {
      final ipAddress = await IpInfoApi.getIPAddress();
      final firestore = FirebaseFirestore.instance;

      if (!mounted) return;

      setState(() => map = {
            'IP Address': ipAddress,
          });

      print(ipAddress);
      print("新規IP保存");
      firestore.collection("IP").add({'IpAddress': ipAddress});
      print("終了");
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monster Grow',
      home: MainPage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     Timer(Duration(seconds: 4), () {
//       Navigator.push(context, MaterialPageRoute(builder: (ctx) => MainPage()));
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.black,
//         body: LayoutBuilder(builder: (context, constraints) {
//           if (constraints.maxWidth > 700) {
//             return Center(
//                 child: Text(
//               'Monster Grow',
//               style: TextStyle(
//                   color: Colors.white, fontFamily: 'StyleScript', fontSize: 65),
//             ));
//           } else {
//             return Center(
//               child: Text(
//                 'Monster Grow',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontFamily: 'StyleScript',
//                     fontSize: 65),
//               ),
//             );
//           }
//         }));
//   }
// }
