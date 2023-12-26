import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/parentModel.dart';

class ParentRegisterRepository {
  final CollectionReference _parentsCollection = FirebaseFirestore.instance.collection("parents");
  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? ''; // Get the current user's ID


  Future<String> registerParent(ParentModel parent) async {
    await _parentsCollection.add({
      'parentId' : currentUserId,
      'parentName': parent.parentName,
      'parentProfilePicture': parent.parentProfilePicture,
      'parentPhoneNumber': parent.parentPhoneNumber,
      'parentEmail': parent.parentEmail,
      'parentPassword': parent.parentPassword,
      'parentRePassword': parent.parentRePassword,
      'role': parent.role,
    });
    return "parent is registered";
  }
}
