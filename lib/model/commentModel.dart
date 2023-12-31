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

  factory Comment.fromDoc(QueryDocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      authorId: data['authorId'],
      text: data['text'],
      timestamp: data['timestamp'],
      feedId: data['feedId'],

    );
  }
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'authorId': authorId,
      'feedId': feedId,
      'timestamp': timestamp,
    };
  }
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      text: json['text'],
      authorId: json['authorId'],
      feedId: json['feedId'],
      timestamp: json['timestamp'],
    );
  }

  @override
  String toString() {
    return 'Comment ID: $id, Text: $text, authorId: $authorId, feedId: $feedId, timestamp: $timestamp';
  }
}