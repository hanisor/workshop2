import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  String? id;
  String? authorId;
  String text;
  String image;
  Timestamp timestamp;
  int likes;


  Feed(
      { this.id,
        this.authorId,
        required this.text,
        required this.image,
        required this.timestamp,
        required this.likes,
      });

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


  static Feed fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json['id'],
      authorId: json['authorId']!= null ? json['authorId'] : '',
      text: json['text'] != null ? json['text'] : '',
      image: json['image']!= null ? json['image'] : '',
      timestamp: json['timestamp'] != null ? json['timestamp'] : Timestamp.now(),
      likes: json['likes']!= null ? int.parse(json['authorId']) : 0,
    );
  }
  @override
  String toString() {
    return 'Feed ID: $id, Author ID: $authorId, Text: $text, Image: $image, Timestamp: $timestamp, Likes: $likes';
  }
}