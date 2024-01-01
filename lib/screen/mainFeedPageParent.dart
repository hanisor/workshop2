import 'package:flutter/material.dart';
import 'package:workshop_test/model/parentModel.dart';
import 'package:workshop_test/screen/addFeedPage.dart';
import 'package:workshop_test/widget/feedContainerBoth.dart';
import '../constants/constants.dart';
import '../model/feedModel.dart';
import '../services/databaseServices.dart';


  class MainFeedPageParent extends StatefulWidget {
    final String? currentUserId;


    const MainFeedPageParent({required this.currentUserId});

    @override
    _MainFeedPageParentState createState() => _MainFeedPageParentState();
  }

  class _MainFeedPageParentState extends State<MainFeedPageParent> {
    List _followingFeeds = [];
    bool _loading = false;

    buildFeeds(Feed feed, ParentModel parent) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: FeedContainerBoth(
          feed: feed,
          parent: parent,
          currentUserId: widget.currentUserId,
          users: [],
        ),
      );
    }

    showFeeds(String? currentUserId) {
      List<Widget> followingFeedsList = [];
      for (Feed feed in _followingFeeds) {
        followingFeedsList.add(FutureBuilder(
            future: parentRef.doc(feed.authorId).get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                ParentModel author = ParentModel.fromDoc(snapshot.data);
                author.id = feed.authorId;
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
      await DatabaseServices.getUserFeeds(widget.currentUserId);
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
                    builder: (context) =>
                        AddFeedPage(
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
            'Feeds',
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
                        : showFeeds(widget.currentUserId),
                  ),

                ],
              )
            ],

          ),

        ),
      );
    }
  }

