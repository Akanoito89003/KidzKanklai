
import 'package:flutter/material.dart';
import '../api_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  // This value will control the Rive input. 
  // 0 = Default, 1 = Pose 1, 2 = Pose 2, etc. (Depending on your Rive setup)
  double _selectedPose = 0; 

  User? get user => _user;
  double get selectedPose => _selectedPose;

  void setUser(User user) {
    _user = user;
    _selectedPose = user.equippedPose.toDouble(); // Auto-sync pose from DB
    notifyListeners();
  }

  void setPose(double poseIndex) {
    _selectedPose = poseIndex;
    notifyListeners();
  }

  // Example: If you want to persist this to the backend later, you would add an async method here.
}
