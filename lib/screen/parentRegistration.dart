import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screen/parentLogin.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../controller/parentRegistrationController.dart';
import '../model/parentModel.dart';
import '../services/storageServices.dart';


class ParentRegistration extends StatefulWidget {

  const ParentRegistration({Key? key}) : super(key: key);


  @override
  State<ParentRegistration> createState() => _ParentRegistrationState();
}

class _ParentRegistrationState extends State<ParentRegistration> {
  final parentNameEditingController = TextEditingController();
  final parentEmailEditingController = TextEditingController();
  final parentPhoneEditingController  = TextEditingController();
  final parentPasswordEditingController  =
  TextEditingController();
  final parentRePassEditingController =
  TextEditingController();

  final _controller = ParentRegistrationController();
  File? _imageFile;
  String imageUrl = '';

  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;
  String? parentName = FirebaseAuth.instance.currentUser?.email;


  void createAccount() async {
    String pName = parentNameEditingController.text.trim();
    String pEmail = parentEmailEditingController.text.trim();
    String pPhone = parentPhoneEditingController.text.trim();
    String pPassword = parentPasswordEditingController.text.trim();
    String pRePassword = parentRePassEditingController.text.trim();
    String pRole = "parent";

    // Ensure _imageFile has been picked before creating the parent
    if (_imageFile != null) {
      // Call the method to upload the image to Firebase Storage
      imageUrl = await StorageService.uploadParentProfilePicture(_imageFile!);
    }

    ParentModel parent = ParentModel(
      parentName: pName,
      parentProfilePicture: imageUrl,
      parentPhoneNumber: pPhone,
      parentEmail: pEmail,
      parentPassword: pPassword,
      parentRePassword: pRePassword,
      role: pRole,
    );

    print('Profile Pic: ${parent.parentProfilePicture}'); // Access profilePic from the 'parent' instance
    print('Name: ${parent.parentName}');
    print('num: ${parent.parentPhoneNumber}'); // Access profilePic from the 'parent' instance
    print('email: ${parent.parentEmail}'); // Access name from the 'parent' instance
    print('pass: ${parent.parentPassword}'); // Access profilePic from the 'parent' instance
    print('re: ${parent.parentRePassword}'); // Access name from the 'parent' instance
// Access name from the 'parent' instance


    await _controller.createAccount(context, parent);

    }


  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);

        // Call the method to upload the image to Firebase Storage
        StorageService.uploadParentProfilePicture(_imageFile!)
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
      appBar: AppBar(backgroundColor: Colors.lightGreen[100],

      ),
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
                      hintText: "Enter your name"),
                  controller: parentNameEditingController,

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
                  controller: parentPhoneEditingController,

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
                    controller: parentEmailEditingController

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
                                ? const Icon(Icons.visibility_off_outlined)
                                : const Icon(Icons.visibility_outlined)),

                        hintText: "Enter your password"),
                    controller: parentPasswordEditingController,



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

                        hintText: "Re-enter your password"),
                    controller: parentRePassEditingController

                ),
              ),


              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all(
                            Colors.white),
                        backgroundColor:
                        MaterialStateProperty.all(
                            Colors.orange[900]),
                      ),
                      onPressed: () {
                        createAccount();

                      }, child: const Text("Register")),


                ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                      MaterialStateProperty.all(
                          Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all(
                          Colors.orange[900]),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ParentLogin();
                          },
                        ),
                      );
                    }, child: const Text("Cancel")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () => Navigator.pop(context,
                        MaterialPageRoute(
                            builder: (context) => ParentLogin(),
                        ),
                    ),
                    child: const Text("Login"),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

