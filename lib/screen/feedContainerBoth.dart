import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workshop_test/constants/constants.dart';
import 'package:workshop_test/model/educatorModel.dart';
import '../model/commentModel.dart';
import '../model/feedModel.dart';
import '../model/parentModel.dart';
import '../services/databaseServices.dart';
import 'commentScreen.dart';

class FeedContainerBoth extends StatefulWidget {
  final Feed feed;
  final ParentModel? parent;
  final EducatorModel? edu;
  final String? currentUserId;
  final List<User> users;

  const FeedContainerBoth({
    Key? key,
    required this.feed,
    this.parent,
    this.edu,
    this.currentUserId,
    required this.users,
  }) : super(key: key);

  @override
  _FeedContainerBothState createState() => _FeedContainerBothState();
}

class _FeedContainerBothState extends State<FeedContainerBoth> {
  int _likesCount = 0;
  bool _isLiked = false;
  final _commentController = TextEditingController();
  final List<Comment> _comments = [];
  List<Comment> _allComments = []; // List to store fetched comments
  late SharedPreferences _prefs;
  String? _authorName;
  String? _profilePictureURL;

  initFeedLikes() async {
    bool isLiked =
    await DatabaseServices.isLikeFeed(widget.parent?.id, widget.feed);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  likeFeed() {
    if (_isLiked) {
      DatabaseServices.unlikeFeed(widget.parent?.id, widget.feed);
      setState(() {
        _isLiked = false;
        _likesCount--;
      });
    } else {
      DatabaseServices.likeFeed(widget.parent?.id, widget.feed);
      setState(() {
        _isLiked = true;
        _likesCount++;
      });
    }
  }

  void _showCommentScreen() {
    print('Current User ID: ${widget.currentUserId}');
    print('Feed ID: ${widget.feed.id}');
    print('Comments: $_allComments');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentScreen(
          currentUserId: widget.currentUserId,
          feedId: widget.feed.id,
        ),
      ),
    );
  }


  @override
  void dispose() {
    _commentController.dispose();
    //_saveComments();
    super.dispose();  }

  @override
  void initState() {
    super.initState();
    _likesCount = widget.feed!.likes;
    //_initializeSharedPreferences();
    initFeedLikes();
    _fetchAuthorDetails();
    // _fetchComments();
  }

  void _fetchAuthorDetails() async {
    String? authorId = widget.feed?.authorId;

    if (widget.parent != null) {
      _authorName = widget.parent!.parentName;
      _profilePictureURL = widget.parent!.parentProfilePicture;
    } else if (widget.edu != null) {
      _authorName = widget.edu!.educatorName;
      _profilePictureURL = widget.edu!.educatorProfilePicture;
    } else {
      // Fetch author details from Firestore using authorId
      DocumentSnapshot authorDoc =
      await FirebaseFirestore.instance.collection('feeds').doc(authorId).get();

      if (authorDoc.exists) {
        setState(() {
          _authorName = authorDoc['name'];
          _profilePictureURL = authorDoc['profilePictureURL'];
        });
      }
    }
  }

/*
  void _fetchComments() async {
    if (mounted) {
      try {
        // Fetch comments directly from Firestore
        List<Comment> comments = await CommentController.fetchCommentsForFeed();
        if (mounted) {
          setState(() {
            _allComments = comments;
          });
        }
      } catch (e) {
        // Handle errors, e.g., print or show an error message
        print('Error fetching comments: $e');
      }
    }
  }

*/



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: _profilePictureURL != null
                      ? NetworkImage(_profilePictureURL!)
                      : AssetImage('path/to/default/image') as ImageProvider,
                ),
                SizedBox(width: 10),
                Text(
                  _authorName ?? 'Author Name',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              widget.feed.text,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(height: 15),
            widget.feed.image.isEmpty
                ? SizedBox.shrink()
                : Container(
              height: 250,
              decoration: BoxDecoration(
                color: AutiTrackColor,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.feed.image),
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.green[900] : Colors.black,
                      ),
                      onPressed: likeFeed,
                    ),
                    Text(
                      _likesCount.toString() + ' Likes',
                    ),
                    IconButton(
                      icon: Icon(Icons.comment_outlined),
                      onPressed: _showCommentScreen, // Invoke the method to show the CommentScreen
                    ),
                  ],
                ),
                Text(
                  widget.feed.timestamp.toDate().toString().substring(0, 19),
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),

            Divider(),
          ],
        ),
      ),
    );
  }
}