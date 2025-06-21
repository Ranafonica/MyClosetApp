import 'package:flutter/material.dart';

extension ScaffoldMessengerExtension on BuildContext {
  void showAppSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}