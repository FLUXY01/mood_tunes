import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'widget/button.dart';
import 'controller/img_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final ImgController _imgController = ImgController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008AD7),
        title: const Text(
          'Mood Tunes',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Alata',
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'animation/home_page.json',
              width: double.infinity,
              height: 400,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Upload a Selfie',
              onPressed: () => _imgController.pickImage(context),
              backgroundColor: const Color(0xFF005F99),
              shadowColor: const Color(0xFF87CEEB),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Take a Photo',
              onPressed: () => _imgController.captureImage(context),
              backgroundColor: const Color(0xFF87CEEB),
              shadowColor: const Color(0xFF005F99),
            ),
          ],
        ),
      ),
    );
  }
}
