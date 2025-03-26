import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  File? _profileImage;

  File? get profileImage => _profileImage;

  ProfileProvider() {
    _loadProfileImage();
  }

  Future<void> setProfileImage(File image) async {
    _profileImage = image;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', image.path);
    notifyListeners();
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      _profileImage = File(imagePath);
      notifyListeners();
    }
  }
}
