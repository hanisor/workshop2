import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/educatorModel.dart';

class EducatorRegistrationController {

  // Method to display a generic error dialog
  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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

  // Method to display the registration failed dialog
  void _showRegistrationFailedDialog(BuildContext context, String content) {
    _showErrorDialog(context, 'Registration Failed', content);
  }

  // Method to validate the form fields
  bool _validateFields(EducatorModel educator) {
    return educator.educatorName.trim().isEmpty ||
        educator.educatorEmail.trim().isEmpty ||
        educator.educatorPassword.trim().isEmpty ||
        educator.educatorRePassword.trim().isEmpty;
  }

  // Method to handle the registration process
  Future<UserCredential?> createAccount(BuildContext context, EducatorModel educator) async {
    if (_validateFields(educator)) {
      _showRegistrationFailedDialog(context, 'Please fill all the details');

    } else if (educator.educatorPassword.trim() != educator.educatorRePassword.trim()) {
      _showRegistrationFailedDialog(context, 'The passwords do not match');

    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: educator.educatorEmail.trim(),
          password: educator.educatorPassword.trim(),
        );

        if (userCredential.user != null) {
          // Get the UID of the newly created user


          Navigator.pop(context);
          return userCredential;
        }
      } on FirebaseAuthException catch (ex) {
        if (ex.code == "email-already-in-use") {
          _showRegistrationFailedDialog(
              context, ex.message ?? 'Registration failed');
          print('FirebaseAuthException: ${ex.message}');
        } else if (ex.code == "weak-password") {
          _showRegistrationFailedDialog(
              context, ex.message ?? 'Registration failed');
          print('FirebaseAuthException: ${ex.message}');
        } else {
          _showErrorDialog(
              context, 'Error', ex.message ?? 'Registration failed');
          print('FirebaseAuthException: ${ex.message}');
        }
      } catch (error) {
        _showErrorDialog(context, 'Error', error.toString());
        print('Error during registration: $error');
      }
    }
    return null;
  }
}