import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post(this.id, this.name, this.description, this.imgURL, this.createdAt,
      this.index, this.fav);
  String id;
  String? name;
  String description;
  String? imgURL;
  Timestamp createdAt;
  int index;
  int fav;
}
