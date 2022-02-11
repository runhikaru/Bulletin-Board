import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bulletin_board/domain/post.dart';

class ThreadModel extends ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  // ? (fetchBookList関数が処理を終えるまでNullだが、のちに値が入りList型になることを明示)
  List<Post>? posts;

  void fetchThread() async {
    final QuerySnapshot snapshot = await firestore.collection('posts').get();

    final List<Post> posts = snapshot.docs.map((DocumentSnapshot document) {
      //mapでDocumentSnapshot型をBook型に変換
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String id = document.id;
      final String? name = data['name'];
      final String description = data['description'];
      final String? imgURL = data['imgURL'];
      final Timestamp createdAt = data['createdAt'];
      final int index = data['index'];
      final int fav = data['fav'];
      return Post(id, name, description, imgURL, createdAt, index, fav);
    }).toList();

    posts.sort((a, b) => a.index.compareTo(b.index));

    this.posts = posts;
    //BookListPage<body<Consumerの処理が走る
    notifyListeners();
  }

  Future favoriteButton(String id, int fav) async {
    firestore.collection('posts').doc(id).update({"fav": fav++});
  }
}

//usersコレクションに変更が加われば始動するものの定義
  // final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('users').snapshots();

    //listenで変更を受け取れる
    //snapshotに変更内容が入る
    // _usersStream.listen((QuerySnapshot snapshot) {
      
      //mapでDocumentSnapshot型をBook型に変換
      // final List<Book> posts = snapshot.docs.map((DocumentSnapshot snapshot) {
      //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      //   final String name = data['name'];
      //   final String description = data['description'];
      //   return Book(name, description);
      // }).toList();
