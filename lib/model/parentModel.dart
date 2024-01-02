import 'package:cloud_firestore/cloud_firestore.dart';

class ParentModel {
  String? id;
  final String parentName;
  String parentProfilePicture;
  final String parentPhoneNumber;
  final String parentEmail;
  final String parentPassword;
  final String parentRePassword;
  final String role;

  var parentFullName;

  ParentModel({
    this.id,
    required this.parentName,
    required this.parentFullName,
    required this.parentProfilePicture,
    required this.parentPhoneNumber,
    required this.parentEmail,
    required this.parentPassword,
    required this.parentRePassword,
    required this.role,
  });
  factory ParentModel.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return ParentModel(
      id: doc.id,
      parentName: data?['parentName'] ?? '', // Use null-aware operator to handle null values
      parentFullName: data?['parentFullName'] ?? '', // Use null-aware operator to handle null values
      parentProfilePicture: data?['parentProfilePicture'] ?? '',
      parentPhoneNumber: data?['parentPhoneNumber'] ?? '',
      parentEmail: data?['parentEmail'] ?? '',
      parentPassword: data?['parentPassword'] ?? '',
      parentRePassword: data?['parentRePassword'] ?? '',
      role: data?['role'] ?? '',
    );
  }


}
