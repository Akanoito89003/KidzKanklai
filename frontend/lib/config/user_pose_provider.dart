// ไฟล์: lib/providers/user_pose_provider.dart
import 'package:flutter/material.dart';

class UserPoseProvider extends ChangeNotifier {
  // ค่าเริ่มต้นอารมณ์/ท่าทาง (0 = Default/Happy, 1 = Angry, etc.)
  double _currentEmotion = 0; 
  
  // ใช้สำหรับ Trigger Reaction (เช่น การแตะ)
  bool _triggerReaction = false;

  double get currentEmotion => _currentEmotion;
  bool get shouldTriggerReaction => _triggerReaction;

  void setEmotion(double emotionIndex) {
    _currentEmotion = emotionIndex;
    notifyListeners();
  }

  // เรียกเมื่อต้องการเปลี่ยน Emotion ถัดไป (เช่นในหน้า Lobby)
  void nextEmotion() {
    _currentEmotion = (_currentEmotion + 1) % 5; // Cycle through 5 emotions
    if (_currentEmotion < 0) _currentEmotion = 0;
    notifyListeners();
  }

  // เรียกเมื่อแตะตัวละคร เพื่อเล่นท่าทาง Reaction
  void triggerReaction() {
    _triggerReaction = true;
    notifyListeners();
    
    // Reset trigger after a short delay so it can be fired again later
    // Note: consumer should handle the 'fire' immediately upon seeing true
    Future.delayed(const Duration(milliseconds: 100), () {
      _triggerReaction = false;
      notifyListeners();
    });
  }
}