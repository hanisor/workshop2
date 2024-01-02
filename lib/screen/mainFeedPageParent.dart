import 'package:flutter/material.dart';
import 'package:workshop_test/model/parentModel.dart';
import 'package:workshop_test/screen/addFeedPage.dart';
import '../constants/constants.dart';
import '../model/feedModel.dart';
import '../services/databaseServices.dart';
import '../widget/feedContainerPersonalPage.dart';
import '../widget/userDetailsContainer.dart';


  class MainFeedPageParent extends StatefulWidget {
    final String? currentUserId;


    const MainFeedPageParent({required this.currentUserId});

    @override
    _MainFeedPageParentState createState() => _MainFeedPageParentState();
  }

  class _MainFeedPageParentState extends State<MainFeedPageParent> {
    List<Feed> _followingFeeds = [];
    bool _loading = false;
    ParentModel? _parent;
    int _profileSegmentedValue = 0;
    List<Feed> _allFeeds = [];
    List<Feed> _mediaFeeds = [];
    bool _userDetailsDisplayed = false;

    buildFeeds(Feed feed, ParentModel parent) {
      print("_userDetailsDisplayed value: $_userDetailsDisplayed");

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_userDetailsDisplayed)
              UserDetailsContainer(parent: _parent),
            SizedBox(height: 10),
            FeedContainerPersonalPage(
              feed: feed,
              parent: parent,
              currentUserId: widget.currentUserId,
              users: [],
              isParent: true,
              isEdu: false,
            ),
          ],
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
      List<Feed> followingFeeds =
      await DatabaseServices.getUserFeeds(widget.currentUserId);
      if (mounted) {
        setState(() {
          _followingFeeds = followingFeeds;
          _mediaFeeds =
              _followingFeeds.where((element) => element.image.isNotEmpty).toList();
          _loading = false;
        });
      }
    }



    @override
    void initState() {
      super.initState();
      setupFollowingFeeds();
      fetchParentDetails(); // Fetch parent details only once

    }
    Future<void> fetchParentDetails() async {
      // Fetch parent details
      DatabaseServices databaseServices = DatabaseServices();
      _parent = await databaseServices.fetchParentDetails(widget.currentUserId);

      if (_parent != null) {
        setState(() {
          _userDetailsDisplayed = true; // Set to true after fetching details
        });
      }
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.amber[50],
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
          backgroundColor: Colors.amber[50],
          elevation: 0.5,
          centerTitle: true,
          leading: Container(
            height: 40,
          ),
          title: Text(
            'Feeds',
            style: TextStyle(
              color: Colors.black,

            ),
          ),
        ),

        body: Column(
          children: [
            //Display UserDetailsContainer only if _parent is not null


            Expanded(
            child : RefreshIndicator(
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
          ),
          ],
        ),
      );
    }
  }

