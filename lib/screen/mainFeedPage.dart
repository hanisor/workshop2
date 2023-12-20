import 'package:flutter/material.dart';
import 'package:workshop_test/model/parentModel.dart';
import 'package:workshop_test/screen/addFeedPage.dart';
import '../constants/constants.dart';
import '../model/feedModel.dart';
import '../services/databaseServices.dart';
import '../widget/feedContainer.dart';

class MainFeedPage extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;


  const MainFeedPage({required this.currentUserId,  required this.visitedUserId});

  @override
  _MainFeedPageState createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> {
  List _followingFeeds = [];
  bool _loading = false;


  buildFeeds(Feed feed, ParentModel author) {
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
              ParentModel author = ParentModel.fromDoc(snapshot.data);
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
    await DatabaseServices.getUserFeeds(widget.visitedUserId);
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
    //getAllFeeds();
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
          }, child: const Icon(Icons.add),

        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          leading: Container(
            height: 40,
          ),
          title: Text(
            'Home Screen',
            style: TextStyle(
              color: AutiTrackColor,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => setupFollowingFeeds(),
          child: ListView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              _loading ? LinearProgressIndicator() : SizedBox.shrink(),
              SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 5),
                  Column(
                    children: _followingFeeds.isEmpty && _loading == false
                        ? [
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'There is No New Tweets',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    ]
                        : showFeeds (widget.currentUserId),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}