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

  ParentModel({
    this.id,
    required this.parentName,
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
      parentProfilePicture: data?['parentProfilePicture'] ?? '',
      parentPhoneNumber: data?['parentPhoneNumber'] ?? '',
      parentEmail: data?['parentEmail'] ?? '',
      parentPassword: data?['parentPassword'] ?? '',
      parentRePassword: data?['parentRePassword'] ?? '',
      role: data?['role'] ?? '',
    );
  }
/*  static ParentModel fromFirestore(Map<String, dynamic> firestoreData) {
    return ParentModel(
      parentName: firestoreData['parentName'] ?? '', // Use null-aware operator to handle null values
      parentProfilePicture: firestoreData['parentProfilePicture'] ?? '',
      parentPhoneNumber: firestoreData['parentPhoneNumber'] ?? '',
      parentEmail: firestoreData['parentEmail'] ?? '',
      parentPassword: firestoreData['parentPassword'] ?? '',
      parentRePassword: firestoreData['parentRePassword'] ?? '',
      role: firestoreData['role'] ?? '',
    );
  }*/

  Map<String, dynamic> toMap() {
    return {
      'parentName': parentName,
      'parentProfilePicture': parentProfilePicture,
      'parentPhoneNumber': parentPhoneNumber,
      'parentEmail': parentEmail,
      'parentPassword': parentPassword,
      'parentRePassword': parentRePassword,
      'role': role,
    };
  }
}
