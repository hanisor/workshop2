import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workshop_test/constants/constants.dart';
import 'package:workshop_test/model/educatorModel.dart';
import '../model/feedModel.dart';
import '../model/parentModel.dart';
import '../services/databaseServices.dart';
import '../screen/commentScreen.dart';

class FeedContainerPersonalPage extends StatefulWidget {
  final Feed feed;
  final ParentModel? parent;
  final EducatorModel? edu;
  final String? currentUserId;
  final List<User> users;
  final bool isParent; // Indicator for user type
  final bool isEdu; // Indicator for user type


  const FeedContainerPersonalPage({
    Key? key,
    required this.feed,
    this.parent,
    this.edu,
    this.currentUserId,
    required this.users,
    required this.isParent,
    required this.isEdu,

  }) : super(key: key);

  @override
  _FeedContainerPersonalPageState createState() => _FeedContainerPersonalPageState();
}

class _FeedContainerPersonalPageState extends State<FeedContainerPersonalPage> {
  int _likesCount = 0;
  bool _isLiked = false;
  final _commentController = TextEditingController();
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
    initFeedLikes();
    _fetchAuthorDetails();
  }

  void _fetchAuthorDetails() async {
    String? authorId = widget.feed?.authorId;

    if (authorId != null) {
      DocumentSnapshot authorSnapshot;

      try {
        // Check if the authorId exists in Parents collection
        authorSnapshot = await FirebaseFirestore.instance.collection('parents').doc(authorId).get();

        if (authorSnapshot.exists) {
          setState(() {
            _authorName = authorSnapshot['parentName'];
            _profilePictureURL = authorSnapshot['parentProfilePicture'];
          });

        } else {
          // If not found in Parents collection, try finding in Educators collection
          authorSnapshot = await FirebaseFirestore.instance.collection('educators').doc(authorId).get();

          if (authorSnapshot.exists) {
            setState(() {
              _authorName = authorSnapshot['educatorName'];
              _profilePictureURL = authorSnapshot['educatorProfilePicture'];
            });

          } else {
          }
        }
      } catch (e) {
        print('Error fetching author details: $e');
      }
    } else {
      print('Author ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
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
                          : AssetImage('assets/profilePic.png') as ImageProvider,
                    ),
                    SizedBox(width: 10),
                    Text(
                      _authorName ?? 'Author Name',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                              onTap: () {
                                String? feedId = widget.feed?.id;
                                String? authorId = widget.feed?.authorId;
                                String timestamp = widget.feed.timestamp.toDate().toString().substring(0, 19);
                                Navigator.pop(context);
                                DatabaseServices.deleteFeedFromUserFeeds(feedId!, authorId!);

                              },
                            ),
                          ),
                        ];
                      },
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
                    :Container(
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
        ],
      ),
    );
  }
}