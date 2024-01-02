import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/educatorModel.dart';
import '../screen/educatorLogin.dart';
import '../controller/educatorRegistrationController.dart';
import '../services/storageServices.dart';

class EducatorRegistration extends StatefulWidget {
  const EducatorRegistration({super.key});

  @override
  State<EducatorRegistration> createState() => _EducatorRegistrationState();
}

class _EducatorRegistrationState extends State<EducatorRegistration> {
  final educatorNameEditingController = TextEditingController();
  final educatorFullNameEditingController = TextEditingController();
  final educatorEmailEditingController = TextEditingController();
  final educatorPhoneEditingController = TextEditingController();
  final educatorExpertiseEditingController = TextEditingController();
  final educatorPasswordEditingController  =
  TextEditingController();
  final educatorRePassEditingController =
  TextEditingController();

  final _controller = EducatorRegistrationController();
  String imageUrl = '';
  File? _imageFile;


  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
  String? uid = FirebaseAuth.instance.currentUser?.uid;


  void createAccount() async {
    String eName = educatorNameEditingController.text.trim();
    String eFullName = educatorFullNameEditingController.text.trim();
    String eEmail = educatorEmailEditingController.text.trim();
    String ePhone = educatorPhoneEditingController.text.trim();
    String eExpertise = educatorExpertiseEditingController.text.trim();
    String ePassword = educatorPasswordEditingController.text.trim();
    String eRePassword = educatorRePassEditingController.text.trim();
    String eRole = "educator";
    String? eId = uid;

    // Ensure _imageFile has been picked before creating the parent
    if (_imageFile != null) {
      // Call the method to upload the image to Firebase Storage
      imageUrl = await StorageService.uploadParentProfilePicture(_imageFile!);
    }

    EducatorModel educator = EducatorModel(
      id: eId, // Assign the 'id' here
      educatorFullName: '',
      educatorName: eName,
      educatorProfilePicture: imageUrl,
      educatorPhoneNumber: ePhone,
      educatorExpertise: eExpertise,
      educatorEmail: eEmail,
      educatorPassword: ePassword,
      educatorRePassword: eRePassword,
      role: eRole,
    );


    await _controller.createAccount(context, educator);

    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      // Access Firestore collection reference for parents or users
      CollectionReference educatorsCollection = FirebaseFirestore
          .instance.collection('educators');

      // Add the parent data to Firestore with the UID as the document ID
      await educatorsCollection.doc(uid).set({
        'educatorName': eName,
        'educatorFullName': eFullName,
        'educatorProfilePicture': imageUrl,
        'educatorPhoneNumber': ePhone,
        'educatorEmail': eEmail,
        'educatorExpertise': eExpertise,
        'educatorPassword': ePassword,
        'educatorRePassword': eRePassword,
        'role': eRole,
      });

      // Proceed with navigation or any other operations after successful document creation
    } catch (error) {
      // Handle any potential errors
      print('Error creating parent document: $error');
    }

  }


  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);

        // Call the method to upload the image to Firebase Storage
        StorageService.uploadEducatorProfilePicture(_imageFile!)
            .then((uploadedImageUrl) {
          // Store the returned imageUrl in your state variable and set it to your ParentModel
          setState(() {
            imageUrl = uploadedImageUrl; // Assign the uploaded image URL to imageUrl
          });
        }).catchError((error) {
          // Handle any upload errors
          print('Error uploading image: $error');
        });
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(backgroundColor: Colors.lightGreen[100],),
      body: Center(

        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),

          child: Column(
          children: [
            Text(
              "Register",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              "Create your account",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.add_photo_alternate),
                    onPressed: _pickImage,

                  ),
                  // Display selected image
                  _imageFile != null
                      ? Image.file(_imageFile!)
                      : Text('No image selected.'),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Colors.deepOrangeAccent),
                      borderRadius: BorderRadius.circular(50.0),

                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: "Enter your full name"),
                controller: educatorFullNameEditingController,

              ),
            ),Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Colors.deepOrangeAccent),
                      borderRadius: BorderRadius.circular(50.0),

                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: "Enter your username"),
                controller: educatorNameEditingController,

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Colors.deepOrangeAccent),
                      borderRadius: BorderRadius.circular(50.0),

                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: "Enter your phone number"),
                keyboardType: TextInputType.phone,
                controller: educatorPhoneEditingController,

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Colors.deepOrangeAccent),
                      borderRadius: BorderRadius.circular(50.0),

                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                    hintText: "Enter your expertise"),
                controller: educatorExpertiseEditingController,

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Colors.deepOrangeAccent),
                      borderRadius: BorderRadius.circular(50.0),

                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: "Enter your email"),
                  keyboardType: TextInputType.emailAddress,
                  controller: educatorEmailEditingController

              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                  obscureText: _obscurePassword2,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Colors.deepOrangeAccent),
                        borderRadius: BorderRadius.circular(50.0),

                      ),
                      prefixIcon: const Icon(Icons.password_outlined),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword2 = !_obscurePassword2;
                            });
                          },
                          icon: _obscurePassword2
                              ? const Icon(Icons.visibility_off_outlined)
                              : const Icon(Icons.visibility_outlined)),

                      hintText: "Enter your password"),
                  controller: educatorPasswordEditingController

              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                  obscureText: _obscurePassword1,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Colors.deepOrangeAccent),
                        borderRadius: BorderRadius.circular(50.0),

                      ),
                      prefixIcon: const Icon(Icons.password_outlined),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword1 = !_obscurePassword1;
                            });
                          },
                          icon: _obscurePassword1
                              ?  Icon(Icons.visibility_off_outlined)
                              :  Icon(Icons.visibility_outlined)),

                      hintText: "Re-enter your password"),
                  controller: educatorRePassEditingController

              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () => Navigator.pop(context,
                      MaterialPageRoute(
                          builder: (context) => EducatorLogin())
                  ),
                  child: const Text("Login"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.orange[900]),
                    ),
                    onPressed: () {
                      createAccount();
                    }, child: const Text("Register")),

                ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.orange[900]),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const EducatorLogin();
                          },
                        ),
                      );
                    }, child: const Text("Cancel")),
              ],
            ),



          ],
          ),
        ),
      ),
    );
  }
}

