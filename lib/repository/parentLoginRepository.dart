// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../model/parentModel.dart';
//
// class ParentLoginRepository {
//   final CollectionReference parentsCollection =
//   FirebaseFirestore.instance.collection("parents Registration");
//
//   Future<void> registerParent(ParentModel parent) async {
//     await parentsCollection.add({
//       'parentId': parent.id,
//       'parentName': parent.name,
//       'parentPhone': parent.phoneNumber,
//       'parentEmail': parent.email,
//       'parentPassword': parent.password,
//       'parentRePassword': parent.rePassword,
//       'role': parent.role,
//     });
//   }
// }
