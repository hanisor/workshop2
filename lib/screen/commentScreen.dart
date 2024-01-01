import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/commentController.dart';
import '../model/commentModel.dart';

class CommentScreen extends StatefulWidget {
  final String? currentUserId;
  final String? feedId;

  const CommentScreen({
    Key? key,
    this.currentUserId,
    required this.feedId,
  }) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> _allComments = []; // Store fetched comments

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  void _fetchComments() async {
    try {
      List<Comment> comments = await CommentController.fetchCommentsForFeed(widget.feedId);
      setState(() {
        _allComments = comments;
       // print('feed: ${widget.feedId}');
      //  print ("comment: $_allComments");
      });
      _allComments.forEach((comment) {
       // print('Feed ID: ${comment.feedId}, Author ID: ${comment.authorId}, Text: ${comment.text}');
      });
    } catch (e) {
      // Handle errors, e.g., print or show an error message
      print('Error fetching comments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CommentsList(allComments: _allComments, currentUserId: widget.currentUserId),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Enter your comment',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_commentController.text.isNotEmpty) {
                      final newComment = Comment(
                        text: _commentController.text,
                        timestamp: Timestamp.fromDate(DateTime.now()),
                        authorId: widget.currentUserId,
                        feedId: widget.feedId,
                      );

                      setState(() {
                        _allComments.add(newComment);
                        _commentController.clear();
                      });

                      await CommentController.createComment(newComment);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentsList extends StatelessWidget {
  final List<Comment> allComments;
  final String? currentUserId;

  const CommentsList({
    Key? key,
    required this.allComments,
    this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: allComments.length,
      itemBuilder: (context, index) {
        Comment comment = allComments[index];
        return FutureBuilder<Map<String, dynamic>?>(
          future: CommentController.getUserInfo(comment.authorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator while fetching user info
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                Map<String, dynamic> userData = snapshot.data!;
                //print('Fetched UserData: $userData'); // Add this line to check the fetched userData

                String userName = 'No Name';
                String userProfilePicture = 'default_profile.jpg';

                //print('Role: ${userData['role']}'); // Check the role retrieved from userData

                if (userData.containsKey('role')) {
                  if (userData['role'] == 'parent') {
                   // print('Inside Parent Role'); // Add this line to check if it enters the parent role condition
                    userName = userData['parentName'] ?? 'No Parent Name';
                    userProfilePicture = userData['parentProfilePicture'] ?? 'default_parent_profile.jpg';
                  } else if (userData['role'] == 'educator') {
                   // print('Inside Educator Role'); // Add this line to check if it enters the educator role condition
                    userName = userData['educatorName'] ?? 'No Educator Name';
                    userProfilePicture = userData['educatorProfilePicture'] ?? 'default_educator_profile.jpg';
                  }
                }

                //print('User Name: $userName'); // Add this line to check the resolved userName

                // Log fetched user data for debugging purposes
               //print('Comment Text: ${comment.text}');
                //print('Fetched User Data - Name: $userName, Profile Picture: $userProfilePicture');

                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(userProfilePicture),
                  ),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        comment.text,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    comment.timestamp.toDate().toString().substring(0, 19),
                  ),
                );

              } else {
                return ListTile(
                  title: Text(comment.text),
                  subtitle: Text(comment.timestamp.toDate().toString().substring(0, 19)),
                  // Display a placeholder or default content if user data couldn't be fetched
                  leading: CircleAvatar(
                    // You can set a default placeholder image or use Icons.account_circle for a default icon
                    child: Icon(Icons.account_circle),
                  ),
                );
              }
            }
            },
        );
      },
    );
  }
}
