import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  Timer? _timer;
  int _seconds = 0;

  int get seconds => _seconds;

  void startTimer() {
    // Проверка, что таймер не запущен
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _seconds++;
        notifyListeners();
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null; // Убедитесь, что таймер обнулен
  }

  void resetTimer() {
    _seconds = 0;
    notifyListeners();
  }
}
