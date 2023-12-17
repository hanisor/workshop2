import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/educatorModel.dart';

class EducatorRegisterRepository {
  final CollectionReference educatorsCollection =
  FirebaseFirestore.instance.collection("educators Registration");

  Future<void> registerEducator(EducatorModel educator) async {
    await educatorsCollection.add({
      'educatorId': educator.id,
      'educatorName': educator.name,
      'educatorProfilePic': educator.profilePic,
      'educatorPhone': educator.phoneNumber,
      'educatorExpertise': educator.expertise,
      'educatorEmail': educator.email,
      'educatorPassword': educator.password,
      'educatorRePassword': educator.rePassword,
      'role': educator.role,
    });
  }
}
