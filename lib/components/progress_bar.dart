import 'package:flutter/material.dart';

class GlobalProgressBar extends StatelessWidget {
  final int totalSteps;
   int currentStep;

  GlobalProgressBar({required this.totalSteps,  this.currentStep = 1});

  @override
  Widget build(BuildContext context) {
    // Calculate progress percentage
    double progress = (currentStep / totalSteps).clamp(0.0, 1.0);

    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}