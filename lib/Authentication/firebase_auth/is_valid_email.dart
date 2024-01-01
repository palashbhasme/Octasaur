import 'package:flutter/material.dart';

class IsValidEmail{
  bool isInstituteEmail(String email) {
    // Regular expression to check if the email is from "@iiitdwd.ac.in"
    RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@iiitdwd\.ac\.in$');
    return regex.hasMatch(email);
  }
}