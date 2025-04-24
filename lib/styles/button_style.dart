import 'package:flutter/material.dart';

class MyButtonStyle {
  static ButtonStyle elevatedButtonStyle({
    double borderRadius = 12.0,

  }) {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),

    );
  }
}