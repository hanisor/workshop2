import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workshop_test/constants/constants.dart';

import '../model/educatorModel.dart';

class EducatorRegisterRepository {
  final CollectionReference educatorsCollection = eduRef;


  Future<void> registerEducator(EducatorModel educator) async {
    await educatorsCollection.add({
      // 'educatorId': educator.id,
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
