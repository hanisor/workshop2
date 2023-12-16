import 'package:cloud_firestore/cloud_firestore.dart';
import '../Constants/Constants.dart';
import '../model/activityModel.dart';
import '../model/feedModel.dart';


class DatabaseServices {
  static final followersRef = FirebaseFirestore.instance.collection('Followers');
  static final followingRef = FirebaseFirestore.instance.collection('Following');
  static final usersRef = FirebaseFirestore.instance.collection('Users');
  static final feedsRef = FirebaseFirestore.instance.collection('Feeds');
  // Initialize other references as needed


  //static Future<int> followersNum(String userId) async {
  //QuerySnapshot followersSnapshot =
  //await followersRef.doc(userId).collection('Followers').get();
  //return followersSnapshot.docs.length;
  //}

  //static Future<int> followingNum(String userId) async {
  // QuerySnapshot followingSnapshot =
  //await followingRef.doc(userId).collection('Following').get();
  //return followingSnapshot.docs.length;
  //}

  static Future<QuerySnapshot> searchUsers(String name) async {
    Future<QuerySnapshot> users = usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: name + 'z')
        .get();

    return users;
  }

  //static void followUser(String currentUserId, String visitedUserId) {
  // followingRef
  //.doc(currentUserId)
  // .collection('Following')
  // .doc(visitedUserId)
  // .set({});
  // followersRef
  // .doc(visitedUserId)
  // .collection('Followers')
  // .doc(currentUserId)
  // .set({});

  //addActivity(currentUserId, null, true, visitedUserId);
  //}

  //static void unFollowUser(String currentUserId, String visitedUserId) {
  //followingRef
  // .doc(currentUserId)
  // .collection('Following')
  // .doc(visitedUserId)
  // .get()
  //  .then((doc) {
  // if (doc.exists) {
  //  doc.reference.delete();
  //  }
  // });

  // followersRef
  //     .doc(visitedUserId)
  //    .collection('Followers')
  //     .doc(currentUserId)
  //    .get()
  //    .then((doc) {
  //  if (doc.exists) {
  //    doc.reference.delete();
//    });
  // }

  //static Future<bool> isFollowingUser(
  //  String currentUserId, String visitedUserId) async {
  // DocumentSnapshot followingDoc = await followersRef
  //   .doc(visitedUserId)
  //  .collection('Followers')
  //  .doc(currentUserId)
  //   .get();
  // return followingDoc.exists;
  // }

  static void createFeed(Feed feed) {
    feedRefs.doc(feed.authorId).set({'tweetTime': feed.timestamp});
    feedRefs.doc(feed.authorId).collection('userFeeds').add({
      'text': feed.text,
      'image': feed.image,
      "authorId": feed.authorId,
      "timestamp": feed.timestamp,
      'likes': feed.likes,
    }).then((doc) async {
      QuerySnapshot followerSnapshot =
      await followersRef.doc(feed.authorId).collection('Followers').get();

      for (var docSnapshot in followerSnapshot.docs) {
        feedRefs.doc(docSnapshot.id).collection('userFeed').doc(doc.id).set({
          'text': feed.text,
          'image': feed.image,
          "authorId": feed.authorId,
          "timestamp": feed.timestamp,
          'likes': feed.likes,
        });
      }
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

  static Future<List> getHomeFeeds(String currentUserId) async {
    QuerySnapshot homeFeeds = await feedRefs
        .doc(currentUserId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .get();

    List<Feed> followingFeeds =
    homeFeeds.docs.map((doc) => Feed.fromDoc(doc)).toList();
    return followingFeeds;
  }

  static void likeFeed(String currentUserId, Feed feed) {
    DocumentReference feedDocProfile =
    tweetsRef.doc(feed.authorId).collection('userTweets').doc(feed.id);
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

//static void addActivity(
// String currentUserId, Feed feed, bool follow, String followedUserId) {
// if (follow) {
//   activitiesRef.doc(followedUserId).collection('userActivities').add({
//   'fromUserId': currentUserId,
//  'timestamp': Timestamp.fromDate(DateTime.now()),
//  "follow": true,
//});
//} else {
//like
// activitiesRef.doc(feed.authorId).collection('userActivities').add({
//  'fromUserId': currentUserId,
//  'timestamp': Timestamp.fromDate(DateTime.now()),
//  "follow": false,
// });
// }
//}
}