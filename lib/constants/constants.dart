import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

const Color AutiTrackColor = Color(0xff9cbca0);

final _fireStore = FirebaseFirestore.instance;

final storageRef = FirebaseStorage.instance.ref();

final parentRef = _fireStore.collection("parents");

final eduRef = _fireStore.collection("educators");

final commentRefs = _fireStore.collection('comments');

final feedRefs = _fireStore.collection('feeds');

final likesRef = _fireStore.collection('likes');

final activitiesRef = _fireStore.collection('activities');