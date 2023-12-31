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
        print('feed: ${widget.feedId}');
        print ("comment: $_allComments");
      });
      _allComments.forEach((comment) {
        print('Feed ID: ${comment.feedId}, Author ID: ${comment.authorId}, Text: ${comment.text}');
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
            child: ListView.builder(
              itemCount: _allComments.length,
              itemBuilder: (context, index) {
                Comment comment = _allComments[index];
                return ListTile(
                  title: Text(comment.text),
                  subtitle: Text(comment.timestamp.toDate().toString().substring(0, 19)),
                );
              },
            ),
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
