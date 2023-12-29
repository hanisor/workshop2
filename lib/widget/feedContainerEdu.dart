import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workshop_test/constants/constants.dart';
import 'package:workshop_test/controller/commentController.dart';
import 'package:workshop_test/model/educatorModel.dart';
import '../model/commentModel.dart';
import '../model/feedModel.dart';
import '../services/databaseServices.dart';

class FeedContainerEdu extends StatefulWidget {
  final Feed feed;
  final EducatorModel edu;
  final String? currentUserId;
  final List<User> users; // Include the list of users here

  const FeedContainerEdu({
    Key? key,
    required this.feed,
    required this.edu,
    required this.currentUserId,
    required this.users, // Pass the list of users

  }) : super(key: key);

  @override
  _FeedContainerEduState createState() => _FeedContainerEduState();
}

class _FeedContainerEduState extends State<FeedContainerEdu> {
  int _likesCount = 0;
  bool _isLiked = false;
  final _commentController = TextEditingController();
  final List<Comment> _comments = [];

  initFeedLikes() async {
    bool isLiked =
    await DatabaseServices.isLikeFeed(widget.edu.id, widget.feed);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  likeFeed() {
    if (_isLiked) {
      DatabaseServices.unlikeFeed(widget.edu.id, widget.feed);
      setState(() {
        _isLiked = false;
        _likesCount--;
      });
    } else {
      DatabaseServices.likeFeed(widget.edu.id, widget.feed);
      setState(() {
        _isLiked = true;
        _likesCount++;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _likesCount = widget.feed.likes;

    // Debugging prints to check profilePic and name
    print('Id: ${widget.feed.authorId}');
    print('Profile Pic: ${widget.edu.educatorProfilePicture}');
    print('Name: ${widget.edu.educatorName}');
    print('text: ${widget.feed.text}');
    print('image: ${widget.feed.image}');

    initFeedLikes();
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
                backgroundImage: widget.edu != null &&
                    widget.edu.educatorProfilePicture.isNotEmpty
                    ? NetworkImage(widget.edu.educatorProfilePicture)
                    : AssetImage('assets/profilePic.png') as ImageProvider<
                    Object>,
              ),
              SizedBox(width: 10),
              Text(
                widget.edu.educatorName,
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

          Container(
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
                      widget.edu != null &&
                          widget.edu.educatorProfilePicture.isNotEmpty
                          ? widget.edu.educatorProfilePicture
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
          ),
          Divider(),
        ],
      ),
    );
  }
}