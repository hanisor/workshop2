  import 'dart:io';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';
  import '../constants/constants.dart';
  import '../model/feedModel.dart';
  import '../services/databaseServices.dart';
  import '../services/storageServices.dart';
  import '../widget/roundedButton.dart';


  class AddFeedPage extends StatefulWidget {
    final String currentUserId;

    const AddFeedPage({Key? key, required this.currentUserId})
        : super(key: key);

    @override
    _AddFeedPageState createState() => _AddFeedPageState();
  }

  class _AddFeedPageState extends State<AddFeedPage> {
    late String _feedText;
    File? _pickedImage;
    bool _loading = false;

    handleImageFromGallery() async {
      try {
        final ImagePicker _picker = ImagePicker();
        File imageFile = (await _picker.pickImage(source: ImageSource.gallery)) as File;
        if (imageFile != null) {
          setState(() {
            _pickedImage = File(imageFile.path);
          });
        }
      } catch (e) {
        print(e);
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
        body: Padding(
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
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        color: AutiTrackColor,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(_pickedImage!),
                        )),
                  ),
                  SizedBox(height: 20),
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
                    String image;
                    if (_pickedImage == null) {
                      image = '';
                    } else {
                      image =
                      await StorageService.uploadFeedPicture(_pickedImage!);
                    }
                    Feed feed = Feed(
                      text: _feedText,
                      image: image,
                      authorId: widget.currentUserId,
                      likes: 0,
                      timestamp: Timestamp.fromDate(
                        DateTime.now(),
                      ), id: '',
                    );
                    DatabaseServices.createFeed(feed);
                    Navigator.pop(context);
                  }
                  setState(() {
                    _loading = false;
                  });
                },
              ),
              SizedBox(height: 20),
              _loading ? CircularProgressIndicator() : SizedBox.shrink()
            ],
          ),
        ),
      );
    }
  }