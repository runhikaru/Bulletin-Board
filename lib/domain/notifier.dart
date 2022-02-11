import 'package:cloud_firestore/cloud_firestore.dart';

class Notifier {
  Notifier(this.title, this.description, this.imgURL, this.createdAt);
  String title;
  String description;
  String? imgURL;
  Timestamp createdAt;
}
