import 'package:flutter/material.dart';
import 'package:workshop_test/screen/addFeedPage.dart';

import '../constants/constants.dart';
import '../model/feedModel.dart';
import '../model/usermodel.dart';
import '../services/databaseServices.dart';
import '../widget/feedContainer.dart';

class MainFeedPage extends StatefulWidget {
  final String currentUserId;

  const MainFeedPage({required this.currentUserId});

  @override
  _MainFeedPageState createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {
  List _followingFeeds = [];
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

  showFeeds(String currentUserId) {
    List<Widget> followingFeedsList = [];
    for (Feed feed in _followingFeeds) {
      followingFeedsList.add(FutureBuilder(
          future: usersRef.doc(feed.authorId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              UserModel author = UserModel.fromDoc(snapshot.data);
              return buildFeeds(feed, author);
            } else {
              return SizedBox.shrink();
            }
          }));
    }
    return followingFeedsList;
  }

  setupFollowingFeeds() async {
    setState(() {
      _loading = true;
    });
    List followingFeeds =
    await DatabaseServices.getHomeFeeds(widget.currentUserId);
    if (mounted) {
      setState(() {
        _followingFeeds = followingFeeds;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupFollowingFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddFeedPage(
                      currentUserId: widget.currentUserId,
                    )));
          },child: Icon(Icons.add), // Icon for the button
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          leading: Container(
            height: 40,
            child: Image.asset('assets/logo_autitrack.png'),
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

