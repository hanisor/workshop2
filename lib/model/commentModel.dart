import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? id;
  String? authorId;
  String text;
  Timestamp timestamp;
  String? feedId;


  Comment(
      { this.id,
        required this.authorId,
        required this.text,
        required this.timestamp,
        this.feedId,
      });

  factory Comment.fromDoc(DocumentSnapshot doc) {
    return Comment(
      id: doc.id,
      authorId: doc['authorId'],
      text: doc['text'],
      timestamp: doc['timestamp'],
      feedId: doc['feedId'],

    );
  }
}