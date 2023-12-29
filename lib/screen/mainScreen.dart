/*
import 'package:flutter/material.dart';
import 'package:workshop_test/model/educatorModel.dart';
import 'package:workshop_test/screen/addFeedPage.dart';
import 'package:workshop_test/widget/feedContainerEdu.dart';
import '../constants/constants.dart';
import '../model/feedModel.dart';
import '../services/databaseServices.dart';
import '../widget/feedContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MainFeedPageEdu extends StatefulWidget {
  final String? currentUserId;


  const MainFeedPageEdu({required this.currentUserId});

  @override
  _MainFeedPageEduState createState() => _MainFeedPageEduState();
}

class _MainFeedPageEduState extends State<MainFeedPageEdu> {
  List _followingFeeds = [];
  bool _loading = false;
  int _selectedTabIndex = 0;
  late List<Widget> _pages;
  late SharedPreferences _prefs;
  late List<Feed> _feeds = [];


  // Feed? get feed {
  //   if (_followingFeeds.isNotEmpty) {
  //     return _followingFeeds.first; // Return the first feed from the list
  //   } else {
  //     return null; // Return null if the list is empty
  //   }
  // }
  //
  // EducatorModel? get edu {
  //   // Assuming edu data is associated with the first feed in the list
  //   if (_followingFeeds.isNotEmpty) {
  //     return _followingFeeds.single; // Access edu from the first feed
  //   } else {
  //     return null; // Return null if the list is empty
  //   }
  // }


  buildFeeds(Feed feed) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: FeedContainer(
        feed: feed,
        currentUserId: widget.currentUserId,
        users: [],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFeedData();
    // setupFollowingFeeds();
    fetchAndSetFeeds();
  }

  Future<void> fetchAndSetFeeds() async {
    List<Feed> fetchedFeeds = await DatabaseServices.fetchAllFeeds();
    setState(() {
      _feeds = fetchedFeeds;
    });
  }

  Future<void> _loadFeedData() async {
    _prefs = await SharedPreferences.getInstance();
    final savedFeedIds = _prefs.getStringList('following_feeds') ?? [];
    setState(() {
      _followingFeeds = savedFeedIds;
    });
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
          'Home Screen',
          style: TextStyle(
            color: AutiTrackColor,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchAndSetFeeds(),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: _feeds.length,
          itemBuilder: (context, index) {
            Feed feed = _feeds[index];
            // Display your feed data here using a FeedContainerEdu or similar widget
            return buildFeeds(feed);
          },
        ),
      ),
    );
  }

  @override
  Widget buildMenu(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTabIndex], // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index; // Update the selected tab index
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          // Add other bottom navigation items as needed
        ],
      ),
    );
  }
}


*/
