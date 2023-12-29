import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Constants/Constants.dart';
import '../model/feedModel.dart';


class DatabaseServices {

  final CollectionReference _feedCollection = FirebaseFirestore.instance.collection('feeds');


  static createFeed(Feed feed) {
    feedRefs.doc(feed.authorId).set({'FeedTime': feed.timestamp});
    feedRefs.doc(feed.authorId).collection('userFeeds').add({
      'text': feed.text,
      'image': feed.image,
      "authorId": feed.authorId,
      "timestamp": feed.timestamp,
      'likes': feed.likes,
    });
  }

  static Future<List> getUserFeeds(String? userId) async {
    QuerySnapshot userFeedsSnap = await feedRefs
        .doc(userId)
        .collection('userFeeds')
        .orderBy('timestamp', descending: true)
        .get();
    List<Feed> userFeeds =
    userFeedsSnap.docs.map((doc) => Feed.fromDoc(doc)).toList();

    return userFeeds;
  }

  Future<List<Feed>> getFeedById() async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return [];
    }

    var querySnapshot = await _feedCollection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => Feed.fromDoc(doc.data() as DocumentSnapshot<Object?>)).toList();
  }



  static void likeFeed(String? currentUserId, Feed feed) {
    DocumentReference feedDocProfile =
    feedRefs.doc(feed.authorId).collection('userTweetsFeeds').doc(feed.id);
    feedDocProfile.get().then((doc) {
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String,
            dynamic>?; // Explicit casting
        if (data != null) {
          int? likes = data['likes'] as int?;
          if (likes != null) {
            feedDocProfile.update({'likes': likes + 1});
          }
        }
      }
    });

    DocumentReference feedDocFeed =
    feedRefs.doc(currentUserId).collection('userFeed').doc(feed.id);
    feedDocFeed.get().then((doc) {
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String,
            dynamic>?; // Explicit casting
        if (data != null) {
          int? likes = data['likes'] as int?;
          if (likes != null) {
            feedDocFeed.update({'likes': likes + 1});
          }
        }
      }
    });

    likesRef.doc(feed.id).collection('feedLikes').doc(currentUserId).set({});
  }


  static void unlikeFeed(String? currentUserId, Feed feed) {
    DocumentReference feedDocProfile =
    feedRefs.doc(feed.authorId).collection('userFeeds').doc(feed.id);
    feedDocProfile.get().then((doc) {
      if (doc.exists) {
        var data = doc.data();
        if (data is Map<String, dynamic>) {
          int? likes = data['likes']; // Null-aware operator used
          if (likes != null) {
            feedDocProfile.update({'likes': likes - 1});
          }
        }
      }
    });

    DocumentReference feedDocFeed =
    feedRefs.doc(currentUserId).collection('userFeed').doc(feed.id);
    feedDocFeed.get().then((doc) {
      if (doc.exists) {
        var data = doc.data();
        if (data is Map<String, dynamic>) {
          int? likes = data['likes']; // Null-aware operator used
          if (likes != null) {
            feedDocFeed.update({'likes': likes - 1});
          }
        }
      }
    });

    likesRef
        .doc(feed.id)
        .collection('feedLikes')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }


  static Future<bool> isLikeFeed(String? currentUserId, Feed feed) async {
    DocumentSnapshot userDoc = await likesRef
        .doc(feed.id)
        .collection('tweetLikes')
        .doc(currentUserId)
        .get();

    return userDoc.exists;
  }

}
