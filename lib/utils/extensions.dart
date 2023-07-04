import 'package:flutter/material.dart';

extension StringToTimeOfDay on String {
  TimeOfDay toTimeOfDay() {
    if (this == null) {
      return null;
    }
    // Parse the string to an integer timestamp
    int timestamp = int.tryParse(this);

    if (timestamp == null) {
      return null;
    }

    // Create a DateTime object from the timestamp (assuming it's in milliseconds)
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Extract the time components from the DateTime object
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    // Create and return the TimeOfDay object
    return TimeOfDay(hour: hour, minute: minute);
  }
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (this == null || this.isEmpty) {
      return this;
    }

    return this[0].toUpperCase() + this.substring(1);
  }
}

extension NumberToAlphabet on int {
  String toAlphabet() {
    // Assuming input is in the range of 0-25
    if (this < 0 || this > 25) {
      throw Exception('Number must be between 0 and 25');
    }

    final charCode = this + 'A'.codeUnitAt(0);
    return String.fromCharCode(charCode);
  }
}