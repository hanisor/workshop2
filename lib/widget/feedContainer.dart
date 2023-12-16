import 'package:flutter/material.dart';
import 'package:workshop_test/constants/constants.dart';
import '../model/feedModel.dart';
import '../model/usermodel.dart';
import '../services/databaseServices.dart';

class FeedContainer extends StatefulWidget {
  final Feed feed;
  final UserModel author;
  final String currentUserId;

  const FeedContainer({
    Key? key,
    required this.feed,
    required this.author,
    required this.currentUserId,
  }) : super(key: key);

  @override
  _FeedContainerState createState() => _FeedContainerState();
}

class _FeedContainerState extends State<FeedContainer> {
  int _likesCount = 0;
  bool _isLiked = false;

  initFeedLikes() async {
    bool isLiked =
    await DatabaseServices.isLikeFeed(widget.currentUserId, widget.feed);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  likeTweet() {
    if (_isLiked) {
      DatabaseServices.unlikeFeed(widget.currentUserId, widget.feed);
      setState(() {
        _isLiked = false;
        _likesCount--;
      });
    } else {
      DatabaseServices.likeFeed(widget.currentUserId, widget.feed);
      setState(() {
        _isLiked = true;
        _likesCount++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _likesCount = widget.feed.likes;
    initFeedLikes(); // Corrected method name
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //CircleAvatar(
              //radius: 20,
              //backgroundImage: widget.author.profilePicture != null &&
              //widget.author.profilePicture.isNotEmpty
              //? NetworkImage(widget.author.profilePicture!)
              //: AssetImage('assets/placeholder.png'),
              //),
              SizedBox(width: 10),
              Text(
                widget.author.name,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            widget.feed.text,
            style: TextStyle(
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
                    )),
              )
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
                    onPressed: likeTweet,
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
          Divider()
        ],
      ),
    );
  }
}