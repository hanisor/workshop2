import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/constants.dart';
import '../model/feedModel.dart';
import '../services/databaseServices.dart';
import '../services/storageServices.dart';
import '../widget/roundedButton.dart';
import 'package:permission_handler/permission_handler.dart';

class AddFeedPage extends StatefulWidget {
  final String currentUserId;

  const AddFeedPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _AddFeedPageState createState() => _AddFeedPageState();
}

class _AddFeedPageState extends State<AddFeedPage> {
  String _feedText = ''; // Initializing _feedText with an empty string
  File _pickedImage = '' as File;
  bool _loading = false;

  Future<void> handleImageFromGallery() async {
    try {
      final PermissionStatus permissionStatus = await _requestPermission();
      if (permissionStatus == PermissionStatus.granted) {
        final ImagePicker _picker = ImagePicker();
        XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedImage != null) {
          setState(() {
            _pickedImage = File(pickedImage.path);
          });
        }
      } else {
        print('image is in Xfile');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<PermissionStatus> _requestPermission() async {
    final PermissionStatus permissionStatus = await Permission.storage.status;
    if (permissionStatus != PermissionStatus.granted) {
      final PermissionStatus result = await Permission.storage.request();
      return result;
    } else {
      return permissionStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AutiTrackColor,
        centerTitle: true,
        title: Text(
          'Feed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                maxLength: 280,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: 'What is on your mind?',
                ),
                onChanged: (value) {
                  _feedText = value;
                },
              ),
              SizedBox(height: 10),
              _pickedImage == null
                  ? SizedBox.shrink()
                  : Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: AutiTrackColor,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(_pickedImage!),
                          ),
                        ),
                      ),
                    ],
                  ),
              GestureDetector(
                onTap: handleImageFromGallery,
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: AutiTrackColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: AutiTrackColor,
                  ),
                ),
              ),
              SizedBox(height: 20),
              RoundedButton(
                btnText: 'Post',
                onBtnPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  if (_feedText != null && _feedText.isNotEmpty) {
                    String imageUrl = ''; // Default empty URL if no image is selected
                    if (_pickedImage != null) {
                      try {
                        // Upload the image and get the URL
                        imageUrl = await StorageService.uploadFeedPicture(_pickedImage!);
                      } catch (e) {
                        // Inside the `catch` blocks for image upload and feed creation errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to upload image. Please try again.'),
                            // Adjust duration, styling, and other properties as needed
                          ),
                        );

                        print('Image upload error: $e');
                        // Handle image upload error (show a message to the user or take appropriate action)
                      }
                    }
                    Feed feed = Feed(
                      text: _feedText,
                      image: imageUrl,
                      authorId: widget.currentUserId,
                      likes: 0,
                      timestamp: Timestamp.fromDate(
                        DateTime.now(),
                      ),
                      id: widget.currentUserId,
                    );
                    try {
                      // Attempt to create the feed
                      DatabaseServices.createFeed(feed);
                      Navigator.pop(context);
                    } catch (e) {
                      print('Feed creation error: $e');
                      // Handle feed creation error (show a message to the user or take appropriate action)
                    }
                  }
                  setState(() {
                    _loading = false;
                  });
                }
              ),
              SizedBox(height: 20),
              _loading ? CircularProgressIndicator() : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
