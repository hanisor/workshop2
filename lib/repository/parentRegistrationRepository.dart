import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workshop_test/Constants/Constants.dart';

import '../model/parentModel.dart';

class ParentRegisterRepository {
  final CollectionReference parentsCollection = usersRef;

  Future<void> registerParent(ParentModel parent) async {
    await parentsCollection.add({
      'parentId': parent.id,
      'parentName': parent.name,
      'parentProfilePicture': parent.profilePic,
      'parentPhone': parent.phoneNumber,
      'parentEmail': parent.email,
      'parentPassword': parent.password,
      'parentRePassword': parent.rePassword,
      'role': parent.role,
    });
  }
}
