import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workshop_test/model/educatorModel.dart';
import '../constants/constants.dart';
import '../model/feedModel.dart';
import '../model/parentModel.dart';
import '../services/databaseServices.dart';
import '../services/storageServices.dart';
import '../widget/roundedButton.dart';
import 'package:permission_handler/permission_handler.dart';

class AddFeedPage extends StatefulWidget {
  final String? currentUserId;

  const AddFeedPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _AddFeedPageState createState() => _AddFeedPageState();
}

class _AddFeedPageState extends State<AddFeedPage> {
  String _feedText = ''; // Initializing _feedText with an empty string
  File? _pickedImage ;
  bool _loading = false;
  ParentModel? _parent;
  EducatorModel? _educator;
  dynamic _user; // A dynamic variable to hold either ParentModel or EducatorModel


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
  void initState() {
    super.initState();
    // Fetch the ParentModel here when the widget is initialized
    fetchUserData();

  }

  //
  // @override
  // void didUpdateWidget(covariant AddFeedPage oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.currentUserId != widget.currentUserId) {
  //     fetchParentModel(); // Fetch ParentModel again with the new currentUserId
  //   }
  // }


  Future<void> fetchUserData() async {
    // Determine user type based on currentUserId
    bool isEducatorUser = await isEducator(widget.currentUserId);

    if (isEducatorUser) {
      await fetchEducatorModel();
      _user = _educator; // Assign fetched EducatorModel to _user
    } else {
      await fetchParentModel();
      _user = _parent; // Assign fetched ParentModel to _user
    }
  }

  Future<bool> isEducator(String? userId) async {
    try {
      if (userId != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('educators')
            .doc(userId)
            .get();

        if (userSnapshot.exists) {
          // Check the 'userType' field to determine the user type
          String? educatorRole = userSnapshot['educatorRole'];

          // Return true if the userType is 'educator', false otherwise
          return educatorRole == 'educator';
        }
      }
    } catch (e) {
      print('Error determining user type: $e');
    }

    // Return false by default or if there's an error
    return false;
  }



  Future<void> fetchParentModel() async {
    // Retrieve ParentModel from Firestore using currentUserId
    ParentModel? parent = await getParentFromFirestore(widget.currentUserId);

    // Handle the fetched ParentModel here (update state or perform actions)
    if (parent != null) {
      setState(() {
        _parent = parent;
      });
    }
  }

  Future<ParentModel?> getParentFromFirestore(String? parentId) async {
    try {
      DocumentSnapshot parentSnapshot = await FirebaseFirestore.instance
          .collection('parents')
          .doc(parentId)
          .get();

      if (parentSnapshot.exists) {
        // If the document exists, return the converted ParentModel
        return ParentModel.fromDoc(parentSnapshot);
      } else {
        // Document does not exist
        print('Document for parentId: $parentId does not exist');
        return null;
      }
    } catch (e) {
      // Error occurred during fetching
      print('Error fetching parent from Firestore: $e');
      return null;
    }
  }

  Future<void> fetchEducatorModel() async {
    // Retrieve ParentModel from Firestore using currentUserId
    EducatorModel? edu = await getEducatorFromFirestore(widget.currentUserId);

    // Handle the fetched ParentModel here (update state or perform actions)
    if (edu != null) {
      setState(() {
        _educator = edu;
      });
    }
  }

  Future<EducatorModel?> getEducatorFromFirestore(String? educatorId) async {
    try {
      DocumentSnapshot educatorSnapshot = await FirebaseFirestore.instance
          .collection('educators')
          .doc(educatorId)
          .get();

      if (educatorSnapshot.exists) {
        // If the document exists, return the converted ParentModel
        return EducatorModel.fromDoc(educatorSnapshot);
      } else {
        // Document does not exist
        print('Document for educatorId: $educatorId does not exist');
        return null;
      }
    } catch (e) {
      // Error occurred during fetching
      print('Error fetching educator from Firestore: $e');
      return null;
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
                          imageUrl = await StorageService.uploadFeedPicture(_pickedImage!);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to upload image. Please try again.'),
                            ),
                          );
                          print('Image upload error: $e');
                        }
                      }

                      if (_user != null) {
                        Feed feed = Feed(
                          text: _feedText,
                          image: imageUrl,
                          likes: 0,
                          timestamp: Timestamp.fromDate(DateTime.now()),
                          authorId: widget.currentUserId,
                          id: '', // Ensure to assign a valid ID for the feed
                        );

                        try {
                          await DatabaseServices.createFeed(feed); // Await the feed creation
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
