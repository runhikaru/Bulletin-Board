import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bulletin_board/domain/notifier.dart';
import 'package:flutter_bulletin_board/domain/post.dart';

class NotifierModel extends ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  List<Notifier>? notifiers;

  void fetchNotifiers() async {
    final QuerySnapshot snapshot =
        await firestore.collection('notifiers').get();

    final List<Notifier> notifiers =
        snapshot.docs.map((DocumentSnapshot document) {
      //mapでDocumentSnapshot型をBook型に変換
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String title = data['title'];
      final String description = data['description'];
      final String? imgURL = data['imgURL'];
      final Timestamp createdAt = data['createdAt'];
      return Notifier(title, description, imgURL, createdAt);
    }).toList();

    notifiers.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    this.notifiers = notifiers;
    //BookListPage<body<Consumerの処理が走る
    notifyListeners();
  }
}
