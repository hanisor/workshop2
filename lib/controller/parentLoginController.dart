import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/parentModel.dart';
import '../screen/mainFeedPageParent.dart';
import '../screen/mainScreen.dart';

class ParentLoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? uid = FirebaseAuth.instance.currentUser?.uid;


  Future<UserCredential?> login(
      BuildContext context, ParentModel parent) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: parent.parentEmail,
        password: parent.parentPassword,
      );
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(currentUserId: uid),
          ),
        );

    }
      return userCredential;
    } on FirebaseAuthException catch (ex) {
      _showLoginFailedDialog(context);
      print('FirebaseAuthException: ${ex.message}');
      return null;
    }
  }

  void _showLoginFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid username or password.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


}
