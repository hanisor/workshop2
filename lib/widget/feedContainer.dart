import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workshop_test/constants/constants.dart';
import 'package:workshop_test/controller/commentController.dart';
import '../model/commentModel.dart';
import '../model/feedModel.dart';
import '../model/parentModel.dart';
import '../services/databaseServices.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FeedContainer extends StatefulWidget {
  final Feed feed;
  final ParentModel parent;
  final String? currentUserId;
  final List<User> users;

  const FeedContainer({
    Key? key,
    required this.feed,
    required this.parent,
    required this.currentUserId,
    required this.users, // Pass the list of users

  }) : super(key: key);

  @override
  _FeedContainerState createState() => _FeedContainerState();
}

class _FeedContainerState extends State<FeedContainer> {
  int _likesCount = 0;
  bool _isLiked = false;
  final _commentController = TextEditingController();
  final List<Comment> _comments = [];
  List<Comment> _allComments = []; // List to store fetched comments
  late SharedPreferences _prefs;


  initFeedLikes() async {
    bool isLiked =
    await DatabaseServices.isLikeFeed(widget.parent.id, widget.feed);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  likeFeed() {
    if (_isLiked) {
      DatabaseServices.unlikeFeed(widget.parent.id, widget.feed);
      setState(() {
        _isLiked = false;
        _likesCount--;
      });
    } else {
      DatabaseServices.likeFeed(widget.parent.id, widget.feed);
      setState(() {
        _isLiked = true;
        _likesCount++;
      });
    }
  }

  // Initialize shared preferences
  void _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    // Load comments from shared preferences
    _loadComments();
  }

  // Save comments to shared preferences
  void _saveComments() {
    String commentsJson = jsonEncode(_comments.map((comment) => comment.toJson()).toList());
    _prefs.setString('comments', commentsJson);
  }

  // Load comments from shared preferences
  void _loadComments() {
    String? commentsJson = _prefs.getString('comments');
    if (commentsJson != null && commentsJson.isNotEmpty) {
      List<dynamic> commentsData = jsonDecode(commentsJson);
      List<Comment> loadedComments = commentsData.map((data) => Comment.fromJson(data)).toList();
      setState(() {
        _comments.clear();
        _comments.addAll(loadedComments);
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _saveComments();
    super.dispose();  }

  @override
  void initState() {
    super.initState();
    _likesCount = widget.feed.likes;
    _initializeSharedPreferences();

    // Debugging prints to check profilePic and name
    print('Id: ${widget.feed.authorId}');
    print('Profile Pic: ${widget.parent.parentProfilePicture}');
    print('Name: ${widget.parent.parentName}');
    print('text: ${widget.feed.text}');
    print('image: ${widget.feed.image}');

    initFeedLikes();
    _fetchComments();

  }

  void _fetchComments() async {
    try {
      List<Comment> comments = await CommentController.fetchCommentsForFeed(widget.feed.id);
      setState(() {
        _allComments = comments;
        print ("comment: $_allComments");
      });
    } catch (e) {
      // Handle errors, e.g., print or show an error message
      print('Error fetching comments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery
          .of(context)
          .size
          .height),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this line
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.parent != null &&
                    widget.parent.parentProfilePicture.isNotEmpty
                    ? NetworkImage(widget.parent.parentProfilePicture)
                    : AssetImage('assets/profilePic.png') as ImageProvider<
                    Object>,
              ),
              SizedBox(width: 10),
              Text(
                widget.parent.parentName,
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
          widget.feed.image.isEmpty
              ? SizedBox.shrink()
              : Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
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
                  ],
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
                ],
              ),
              Text(
                widget.feed.timestamp.toDate().toString().substring(0, 19),
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          SizedBox(height: 10),

          TextField(
            controller: _commentController,
            decoration: InputDecoration(hintText: 'Enter your comment'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newComment = Comment(
                text: _commentController.text,
                timestamp: Timestamp.fromDate(DateTime.now()),
                authorId: widget.currentUserId,
                feedId: widget.feed.id
              );

              setState(() {
                _comments.add(newComment);
                _commentController.clear();
              });

              await CommentController.createComment(newComment);
            },
            child: Text('Submit Comment'),
          ),

          Column(
            children: _allComments.map((comment) {
              return ListTile(
                title: Text(comment.text),

                    
              );
            }).toList(),
          ),

          Column(
            children: _allComments.map((comment) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    // Use the appropriate profile picture here
                    widget.parent != null && widget.parent.parentProfilePicture.isNotEmpty
                        ? widget.parent.parentProfilePicture
                        : 'assets/profilePic.png',
                  ),
                ),
                title: Text(
                  comment.text,
                  style: const TextStyle(fontSize: 15),
                ),
                subtitle: Text(
                  comment.timestamp.toDate().toString().substring(0, 19),
                ),
              );
            }).toList(),
          ),

        /*  Container(
            height: 80,
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                User? author;
                for (final user in widget.users) {
                  if (user.uid == comment.authorId) {
                    author = user;
                    break;
                  }
                }

                TextSpan usernameSpan;
                if (author != null) {
                  usernameSpan = TextSpan(
                    text: '${author.displayName}: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                } else {
                  usernameSpan = TextSpan(text: 'Unknown user: ');
                }

                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      widget.parent != null &&
                          widget.parent.parentProfilePicture.isNotEmpty
                          ? widget.parent.parentProfilePicture
                          : 'assets/profilePic.png', // Use appropriate default image
                    ),
                  ),
                  title: RichText(
                    text: TextSpan(
                      children: [
                        usernameSpan,
                        TextSpan(text: comment.text),
                      ],
                    ),
                  ),
                  subtitle: Text(comment.timestamp.toDate().toString().substring(0, 19)),
                );
              },
            ),
          ),*/

          Divider(),
        ],
      ),
    );
  }
}