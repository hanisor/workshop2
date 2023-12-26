import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workshop_test/constants/constants.dart';
import '../model/feedModel.dart';
import '../model/parentModel.dart';
import '../services/databaseServices.dart';

class FeedContainer extends StatefulWidget {
  final Feed feed;
  final ParentModel parent;
  final String currentUserId;

  const FeedContainer({
    Key? key,
    required this.feed,
    required this.parent,
    required this.currentUserId,
  }) : super(key: key);

  @override
  _FeedContainerState createState() => _FeedContainerState();
}

class _FeedContainerState extends State<FeedContainer> {
  int _likesCount = 0;
  bool _isLiked = false;
  late ParentModel _parentModel;


  initFeedLikes() async {
    bool isLiked =
    await DatabaseServices.isLikeFeed(widget.currentUserId, widget.feed);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  likeFeed() {
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
    // initParentModel();// Corrected method name

    // Debugging prints to check profilePic and name
    print('Profile Pic: ${widget.parent.parentProfilePicture}');
    print('Name: ${widget.parent.parentName}');
    print('text: ${widget.feed.text}');
    print('image: ${widget.feed.image}');

    initFeedLikes();
  }

  // Future<void> initParentModel() async {
  //   try {
  //     ParentModel parent = await DatabaseServices.getParentModelData(widget.feed.authorId);
  //     setState(() {
  //       _parentModel = parent;
  //     });
  //   } catch (e) {
  //     print("Error initializing ParentModel: $e");
  //     setState(() {
  //       _parentModel = ParentModel(
  //         //id: widget.currentUserId,
  //         parentName: 'Name', // Use null-aware operator to handle null values
  //         parentProfilePicture: 'parentProfilePicture',
  //         parentPhoneNumber: 'parentPhoneNumber',
  //         parentEmail: 'parentEmail',
  //         parentPassword: 'parentPassword',
  //         parentRePassword:'parentRePassword',
  //         role: 'role',
  //       );  // Handle error by assigning an empty model
  //     });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Provide width constraints
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.parent != null &&
                    widget.parent.parentProfilePicture.isNotEmpty
                    ? NetworkImage(widget.parent.parentProfilePicture)
                    : AssetImage('assets/placeholder.png') as ImageProvider<Object>,

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
          Divider()
        ],
      ),
    );
  }
}
