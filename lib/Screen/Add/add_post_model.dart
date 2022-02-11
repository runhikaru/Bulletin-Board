import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostModel extends ChangeNotifier {
  final firestore = FirebaseFirestore.instance.collection('posts');
  String? name;
  String description = "";
  File? imageFile;
  bool isLoading = false;
  late int index;

  final picker = ImagePicker();

  Future addBook() async {
    if (description.length < 5) {
      throw '5文字以上で投稿してください';
    }

    final doc = firestore.doc();

    String? imgURL;
    if (imageFile != null) {
      // storageにアップロード
      final task = await FirebaseStorage.instance
          .ref('posts/${doc.id}')
          .putFile(imageFile!);
      imgURL = await task.ref.getDownloadURL();
    }

    firestore.get().then((snap) => {index = snap.size + 1});

    await firestore.add(
      {
        'name': name,
        'description': description,
        'imgURL': imgURL,
        'createdAt': Timestamp.now(),
        'index': index++,
        'fav': 0
      },
    );

    // firestoreに追加
    //   await doc.set({
    //     'name': name,
    //     'description': description,
    //     'imgURL': imgURL,
    //     'createdAt': Timestamp.now(),
    //   });
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }
}
