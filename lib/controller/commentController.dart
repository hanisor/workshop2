import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workshop_test/constants/constants.dart';
import 'package:workshop_test/model/commentModel.dart';

class CommentController {

  static Future<void> addCommentToFeed(
      String feedId, Comment comment) async {
    try {
      await FirebaseFirestore.instance
          .collection('feeds')
          .doc(feedId)
          .collection('comments')
          .add({
        'text': comment.text,
        'timestamp': comment.timestamp,
        'authorId': comment.authorId,
      });
    } catch (e) {
      // Handle error
      print('Error adding comment: $e');
    }
  }

  static createComment(Comment comment) {
    commentRefs.doc(comment.feedId).set({'FeedTime': comment.timestamp});
    commentRefs.doc(comment.feedId).collection('comments').add({
      'text': comment.text,
      'timestamp': comment.timestamp,
      'authorId': comment.authorId,
      'feedId': comment.feedId,
    });
  }

}