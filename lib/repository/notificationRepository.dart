import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/notificationModel.dart';

class NotificationRepository {
  final CollectionReference notificationCollection =
  FirebaseFirestore.instance.collection("notification");

  Future<void> notificationDetail (NotificationModel notification) async {
    await notificationCollection.add({
      'notificationTitle': notification.title,
      'notificationDescription': notification.description,
    });
  }
}
