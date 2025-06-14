import 'package:flutter/material.dart';

class MechanicStatsProvider with ChangeNotifier {
  int _pending = 0;
  int _completed = 0;
  double _rating = 0.0;

  int get pending => _pending;
  int get completed => _completed;
  double get rating => _rating;

  Future<void> loadStats() async {
    // Implementation to load stats from backend
<<<<<<< HEAD
    _pending = 12;
    _completed = 24;
    _rating = 4.8;
=======
    _pending = 12; // Example data
    _completed = 24; // Example data
    _rating = 4.8; // Example data
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
    notifyListeners();
  }
}
