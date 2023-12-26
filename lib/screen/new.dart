// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:workshop_test/screen/addFeedPage.dart';
//
// import '../constants/constants.dart';
// import '../model/feedModel.dart';
// import '../model/parentModel.dart';
// import '../services/databaseServices.dart';
// import '../widget/feedContainer.dart';
//
// class HomeScreen extends StatefulWidget {
//   final String currentUserId;
//
//   const HomeScreen({Key? key, required this.currentUserId}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
//
// class _HomeScreenState extends State<HomeScreen> {
//   List _followingTweets = [];
//   bool _loading = false;
//   late final ParentModel parent;
//
//
//   buildTweets(Feed feed, ParentModel parent) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 15),
//       child: FeedContainer(
//         feed: feed,
//         parent: parent,
//         currentUserId: widget.currentUserId,
//       ),
//     );
//   }
//
//   showFollowingTweets(String currentUserId) {
//     List<Widget> followingTweetsList = [];
//     for (Feed feed in _followingTweets) {
//       followingTweetsList.add(FutureBuilder<DocumentSnapshot>(
//           future: parentRef.doc(feed.parentId).get(),
//           builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//             if (snapshot.hasData && snapshot.data != null) {
//               ParentModel parent = ParentModel.fromFirestore(snapshot.data!.data() as Map<String, dynamic>);
//               return buildTweets(feed, parent);
//             } else {
//               return SizedBox.shrink();
//             }
//           }));
//     }
//     return followingTweetsList;
//   }
//
//
//   setupFollowingTweets() async {
//     setState(() {
//       _loading = true;
//     });
//     List followingTweets =
//     await DatabaseServices.getUserFeeds(widget.currentUserId);
//     if (mounted) {
//       setState(() {
//         _followingTweets = followingTweets;
//         _loading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     setupFollowingTweets();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: Colors.white,
//           onPressed: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => AddFeedPage(
//                       currentUserId: widget.currentUserId,
//                     )));
//           }, child: const Icon(Icons.add),
//
//         ),
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0.5,
//           centerTitle: true,
//           leading: Container(
//             height: 40,
//           ),
//           title: Text(
//             'Home Screen',
//             style: TextStyle(
//               color: AutiTrackColor,
//             ),
//           ),
//         ),
//         body: RefreshIndicator(
//           onRefresh: () => setupFollowingTweets(),
//           child: ListView(
//             physics: BouncingScrollPhysics(
//               parent: AlwaysScrollableScrollPhysics(),
//             ),
//             children: [
//               _loading ? LinearProgressIndicator() : SizedBox.shrink(),
//               SizedBox(height: 5),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   SizedBox(height: 5),
//                   Column(
//                     children: _followingTweets.isEmpty && _loading == false
//                         ? [
//                       SizedBox(height: 5),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 25),
//                         child: Text(
//                           'There is No New Tweets',
//                           style: TextStyle(
//                             fontSize: 20,
//                           ),
//                         ),
//                       )
//                     ]
//                         : showFollowingTweets(widget.currentUserId),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ));
//   }
// }