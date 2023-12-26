import 'package:cloud_firestore/cloud_firestore.dart';
import '../Constants/Constants.dart';
import '../model/activityModel.dart';
import '../model/feedModel.dart';


class DatabaseServices {

  static void createFeed(Feed feed) {
    feedRefs.doc(feed.authorId).set({'FeedTime': feed.timestamp});
    feedRefs.doc(feed.authorId).collection('userFeeds').add({
      'text': feed.text,
      'image': feed.image,
      "authorId": feed.authorId,
      "timestamp": feed.timestamp,
      'likes': feed.likes,
    });
  }

  static Future<List> getUserFeeds(String userId) async {
    QuerySnapshot userFeedsSnap = await feedRefs
        .doc(userId)
        .collection('userFeeds')
        .orderBy('timestamp', descending: true)
        .get();
    List<Feed> userFeeds =
    userFeedsSnap.docs.map((doc) => Feed.fromDoc(doc)).toList();

    return userFeeds;
  }


  static void likeFeed(String currentUserId, Feed feed) {
    DocumentReference feedDocProfile =
    feedRefs.doc(feed.authorId).collection('userTweetsFeeds').doc(feed.id);
    feedDocProfile.get().then((doc) {
      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?; // Explicit casting
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
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?; // Explicit casting
        if (data != null) {
          int? likes = data['likes'] as int?;
          if (likes != null) {
            feedDocFeed.update({'likes': likes + 1});
          }
        }
      }
    });

    likesRef.doc(feed.id).collection('feedLikes').doc(currentUserId).set({});

    addActivity(currentUserId, feed, false, '');
  }


  static void unlikeFeed(String currentUserId, Feed feed) {
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


  static Future<bool> isLikeFeed(String currentUserId, Feed feed) async {
    DocumentSnapshot userDoc = await likesRef
        .doc(feed.id)
        .collection('tweetLikes')
        .doc(currentUserId)
        .get();

    return userDoc.exists;
  }

  static Future<List<Activity>> getActivities(String userId) async {
    QuerySnapshot userActivitiesSnapshot = await activitiesRef
        .doc(userId)
        .collection('userActivities')
        .orderBy('timestamp', descending: true)
        .get();

    List<Activity> activities = userActivitiesSnapshot.docs
        .map((doc) => Activity.fromDoc(doc))
        .toList();

    return activities;
  }

  static void addActivity(String currentUserId, Feed feed, bool bool, String s) {}

}