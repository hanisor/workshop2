import 'package:flutter/material.dart';

class NotificationModel {
  IconData icon;
  String title;
  String description;
  bool isSwitched;

  NotificationModel({
    required this.icon,
    required this.title,
    required this.description,
    this.isSwitched = false,
  });
}