import 'package:cloud_firestore/cloud_firestore.dart';

class ParentModel {
  final String? id;
  final String? profilePic;
  final String name;
  final String phoneNumber;
  final String email;
  final String password;
  final String rePassword;
  final String role;

  const ParentModel ({
    this.id,
    required this.name,
    required this.profilePic,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.role,
  });
  factory ParentModel.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      // Handle the case when the document data is null
      return ParentModel(
        // Set default values or handle it as needed
        id: null,
        name: '',
        profilePic: '',
        phoneNumber: '',
        email: '',
        password: '',
        rePassword: '',
        role: 'parent',
      );
    }

    return ParentModel(
      id: doc.id,
      name: data['parentName'] ?? '', // Use null-aware operator to handle null values
      profilePic: data['parentProfilePicture'] ?? '',
      phoneNumber: data['parentPhoneNumber'] ?? '',
      email: data['parentEmail'] ?? '',
      password: data['parentPassword'] ?? '',
      rePassword: data['parentRePassword'] ?? '',
      role: data['role'] ?? '',
    );
  }

}