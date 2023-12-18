import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:workshop_test/controller/educatorLoginController.dart';
import '../model/educatorModel.dart';
import '../screen/educatorLogin.dart';

import '../controller/educatorRegistrationController.dart';

class EducatorRegistration extends StatefulWidget {
  const EducatorRegistration({super.key});

  @override
  State<EducatorRegistration> createState() => _EducatorRegistrationState();
}

class _EducatorRegistrationState extends State<EducatorRegistration> {
  final _registerController = EducatorRegistrationController(); // Initialize ParentLoginController
  final educatorNameEditingController = TextEditingController();
  final educatorEmailEditingController = TextEditingController();
  final educatorPhoneEditingController = TextEditingController();
  final educatorExpertiseEditingController = TextEditingController();
  final educatorPasswordEditingController  =
  TextEditingController();
  final educatorRePassEditingController =
  TextEditingController();

  final _controller = EducatorRegistrationController();
  final Uuid uuid = Uuid();

  bool _obscurePassword1 = true;
  bool _obscurePassword2 = true;

  void createAccount() async {
    String eName = educatorNameEditingController.text.trim();
    String eEmail = educatorEmailEditingController.text.trim();
    String ePhone = educatorPhoneEditingController.text.trim();
    String eExpertise = educatorExpertiseEditingController.text.trim();
    String ePassword = educatorPasswordEditingController.text.trim();
    String eRePassword = educatorRePassEditingController.text.trim();
    String eRole = "educator";
    String educatorId = uuid.v4(); // Generate a random UUID
    //String? eprofilePicPath = _imageFile != null ? _imageFile!.path : null;



    EducatorModel educator = EducatorModel(
      id: educatorId, // Assign the 'id' here
      name: eName,
      profilePic: '',
      phoneNumber: ePhone,
      expertise: eExpertise,
      email: eEmail,
      password: ePassword,
      rePassword: eRePassword,
      role: eRole,
    );


    await _controller.createAccount(context, educator);

  }

  // File? _imageFile;
  //
  // Future<void> _pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final File? feedPickedImage = await _picker.pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if (feedPickedImage != null) {
  //       _imageFile = File(feedPickedImage.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }




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

            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Column(
            //     children: [
            //       IconButton(
            //         icon: Icon(Icons.add_photo_alternate),
            //         onPressed: _pickImage,
            //       ),
            //       // Display selected image
            //       _imageFile != null
            //           ? Image.file(_imageFile!)
            //           : Text('No image selected.'),
            //     ],
            //   ),
            // ),

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
                    hintText: "Enter your name"),  controller: educatorNameEditingController,

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
                    hintText: "Enter your email"), keyboardType: TextInputType.emailAddress, controller: educatorEmailEditingController

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

