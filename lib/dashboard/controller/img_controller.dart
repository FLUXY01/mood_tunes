import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mood_tunes/user_image/user_image.dart';

class ImgController {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserImage(imagePath: image.path),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No image selected.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> captureImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserImage(imagePath: image.path),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No image captured.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
