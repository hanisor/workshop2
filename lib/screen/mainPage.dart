import 'package:flutter/material.dart';
import 'package:workshop_test/screen/addFeedPage.dart';

import '../constants/constants.dart';
import '../model/feedModel.dart';
import '../model/usermodel.dart';
import '../widget/feedContainer.dart';

class MainPage extends StatefulWidget {
  final String currentUserId;

  const MainPage({required this.currentUserId});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _loading = false;

  buildFeeds(Feed feed, UserModel author) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: FeedContainer(
        feed: feed,
        author: author,
        currentUserId: widget.currentUserId,
      ),
    );
  }

  // showFollowingTweets(String currentUserId) {
  //   List<Widget> followingTweetsList = [];
  //   for (Tweet tweet in _followingTweets) {
  //     followingTweetsList.add(FutureBuilder(
  //         future: usersRef.doc(tweet.authorId).get(),
  //         builder: (BuildContext context, AsyncSnapshot snapshot) {
  //           if (snapshot.hasData) {
  //             UserModel author = UserModel.fromDoc(snapshot.data);
  //             return buildTweets(tweet, author);
  //           } else {
  //             return SizedBox.shrink();
  //           }
  //         }));
  //   }
  //   return followingTweetsList;
  // }
  //
  // setupFollowingTweets() async {
  //   setState(() {
  //     _loading = true;
  //   });
  //   List followingTweets =
  //   await DatabaseServices.getHomeTweets(widget.currentUserId);
  //   if (mounted) {
  //     setState(() {
  //       _followingTweets = followingTweets;
  //       _loading = false;
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   setupFollowingTweets();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Image.asset('assets/logo_autitrack.png'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddFeedPage(
                      currentUserId: widget.currentUserId,
                    )));
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          leading: Container(
            height: 40,
            //child: Image.asset('assets/logo.png'),
          ),
          title: Text(
            'Home Screen',
            style: TextStyle(
              color: AutiTrackColor,
            ),
          ),
        ),
        body:  ListView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              _loading ? LinearProgressIndicator() : SizedBox.shrink(),
              SizedBox(height: 5),

                ],
              )
          );
  }
}