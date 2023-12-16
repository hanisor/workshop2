import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  String id;
  String authorId;
  String text;
  String image;
  Timestamp timestamp;
  int likes;

  Feed(
      {required this.id,
        required this.authorId,
        required this.text,
        required this.image,
        required this.timestamp,
        required this.likes});

  factory Feed.fromDoc(DocumentSnapshot doc) {
    return Feed(
      id: doc.id,
      authorId: doc['authorId'],
      text: doc['text'],
      image: doc['image'],
      timestamp: doc['timestamp'],
      likes: doc['likes'],
    );
  }
}