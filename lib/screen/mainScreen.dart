import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workshop_test/model/parentModel.dart';
import 'package:workshop_test/screen/addFeedPage.dart';
import 'package:workshop_test/screen/feedContainerBoth.dart';
import '../constants/constants.dart';
import '../model/educatorModel.dart';
import '../model/feedModel.dart';
import '../services/databaseServices.dart';
import '../widget/feedContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MainScreen extends StatefulWidget {
  final String? currentUserId;


  const MainScreen({required this.currentUserId});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List _followingFeeds = [];
  bool _loading = false;
  late SharedPreferences _prefs;
  List<Feed> _allFeeds = []; // Add a list to store all feeds
  List<QueryDocumentSnapshot> feedItems = [];

  buildFeeds(Feed feed, {ParentModel? parent, EducatorModel? edu}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: FeedContainerBoth(
        feed: feed,
        parent: parent,
        edu: edu,
        currentUserId: widget.currentUserId,
        users: [],
      ),
    );
  }
  Widget showFeeds(Feed feed)  {
    return FutureBuilder<DocumentSnapshot>(
      future: parentRef.doc(feed.authorId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while waiting for data
        } else if (snapshot.hasData && snapshot.data != null) {
          DocumentSnapshot userData = snapshot.data!;
          if (userData.exists) {
            List<Widget> followingFeedsList = [];
            for (Feed feed in _followingFeeds) {
              if (userData['role'] == "parent") {
                ParentModel parent = ParentModel.fromDoc(userData);
                parent.id = feed.authorId;
                followingFeedsList.add(buildFeeds(feed, parent: parent));
              } else {
                EducatorModel edu = EducatorModel.fromDoc(userData);
                edu.id = feed.authorId;
                followingFeedsList.add(buildFeeds(feed, edu: edu));
              }
            }
            return Column(children: followingFeedsList);
          } else {
            return const SizedBox.shrink(); // Return an empty SizedBox if there's no data
          }
        } else {
          return const SizedBox.shrink(); // Return an empty SizedBox if there's no data
        }
      },
    );
  }

  Future<void> setupFollowingFeeds() async {
    setState(() {
      _loading = true;
    });

    // Fetch feeds directly from Firestore
    _allFeeds = await DatabaseServices.retrieveSubFeeds();

    if (mounted) {
      setState(() {
        _loading = false;
      });

      // Set the fetched feeds directly to _followingFeeds
      _followingFeeds = _allFeeds.toList(); // Assuming all fetched feeds are to be followed

      print('Fetched Feeds:');
      _allFeeds.forEach((feed) {
        print('Feed ID: ${feed.id}, Author ID: ${feed.authorId}, Text: ${feed.text}');
      });

      print('Following Feeds:');
      _followingFeeds.forEach((feed) {
        print('Feed ID: ${feed.id}, Author ID: ${feed.authorId}, Text: ${feed.text}');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFeedData();
    setupFollowingFeeds();
  }

  Future<void> _loadFeedData() async {
    _prefs = await SharedPreferences.getInstance();
    final savedFeedIds = _prefs.getStringList('following_feeds') ?? [];
    setState(() {
      _followingFeeds = savedFeedIds;
    });
  }

  Future<void> _saveFeedData(List<String> feedIds) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setStringList('following_feeds', feedIds);
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
                  : _followingFeeds.map((feed) => showFeeds(feed)).toList(),
            ),
          ],
      ),
      ),
        );
  }
}

