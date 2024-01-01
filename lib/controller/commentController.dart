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
 /* static Future<List<Comment>> fetchCommentsForFeed(String? feedId) async {
    List<Comment> _allComments = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('comments')
          .where('feedId', isEqualTo: feedId)
          .get();

      _allComments =
          querySnapshot.docs.map((doc) => Comment.fromDoc(doc)).toList();
    } catch (e) {
      // Handle error
      print('Error fetching comments: $e');
    }
    print("comment : $_allComments");
    return _allComments;
  }
*/

  static Future<List<Comment>> fetchComments(String? feedId) async {
    List<Comment> comments = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("comments")
          .where('feedId', isEqualTo: feedId)
          .get();

      comments = querySnapshot.docs
          .map((doc) => Comment.fromDoc(doc))
          .toList();
    } catch (e) {
      print("Error retrieving comments for feed: $e");
    }

    return comments;
  }

  static Future<List<Comment>> fetchCommentsForFeed(String? feedId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('comments')
          .doc(feedId)
          .collection('comments')
          .get();

      List<Comment> comments = querySnapshot.docs
          .map((doc) => Comment.fromDoc(doc))
          .toList();

      return comments;
    } catch (e) {
      print('Error fetching comments for feed: $e');
      return []; // Return an empty list or handle the error accordingly
    }
  }
  static Future<Map<String, dynamic>?> getUserInfo(String? authorId) async {
    try {
      DocumentSnapshot parentSnapshot = await FirebaseFirestore.instance
          .collection('parents')
          .doc(authorId)
          .get();

      if (parentSnapshot.exists) {
        print('Parent data exists: ${parentSnapshot.data()}');
        return parentSnapshot.data() as Map<String, dynamic>;
      }

      DocumentSnapshot educatorSnapshot = await FirebaseFirestore.instance
          .collection('educators')
          .doc(authorId)
          .get();

      if (educatorSnapshot.exists) {
        print('Educator data exists: ${educatorSnapshot.data()}');
        return educatorSnapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching user: $e');
    }

    print('No user data found for authorId: $authorId');
  }

}
