import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/parentModel.dart';
import '../screen/addFeedPage.dart';
import '../screen/mainFeedPage.dart';

class ParentLoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> login(
      BuildContext context, ParentModel parent) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: parent.email,
        password: parent.password,
      );
      if (userCredential.user != null) {
        String currentUserId = userCredential.user!.uid; // Assuming uid is the user ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainFeedPage(currentUserId: currentUserId, visitedUserId: currentUserId,),
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
