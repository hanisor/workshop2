import 'package:cloud_firestore/cloud_firestore.dart';

class EducatorModel {
  String? id;
  final String educatorName;
  String educatorProfilePicture;
  final String educatorExpertise;
  final String educatorPhoneNumber;
  final String educatorEmail;
  final String educatorPassword;
  final String educatorRePassword;
  final String educatorRole;

  EducatorModel ({
    this.id,
    required this.educatorName,
    required this.educatorProfilePicture,
    required this.educatorExpertise,
    required this.educatorPhoneNumber,
    required this.educatorEmail,
    required this.educatorPassword,
    required this.educatorRePassword,
    required this.educatorRole,
  });

  factory EducatorModel.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return EducatorModel(
      id: doc.id,
      educatorName: data?['educatorName'] ?? '', // Use null-aware operator to handle null values
      educatorProfilePicture: data?['educatorProfilePicture'] ?? '',
      educatorExpertise: data?['educatorExpertise'] ?? '',
      educatorPhoneNumber: data?['educatorPhoneNumber'] ?? '',
      educatorEmail: data?['educatorEmail'] ?? '',
      educatorPassword: data?['educatorPassword'] ?? '',
      educatorRePassword: data?['educatorRePassword'] ?? '',
      educatorRole: data?['educatorRole'] ?? '',
    );
  }
}