// ไฟล์: lib/utils/rive_cache.dart
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveCache {
  static final RiveCache _instance = RiveCache._internal();
  factory RiveCache() => _instance;
  RiveCache._internal();

  RiveFile? _file;
  bool _isLoading = false;

  /// เรียกใช้ฟังก์ชันนี้ที่ main.dart เพื่อโหลดโมเดลรอไว้ก่อน
  Future<void> loadAsset(String assetPath) async {
    if (_file != null) return;
    if (_isLoading) return;

    _isLoading = true;
    try {
      print("RiveCache: Start loading $assetPath...");
      await RiveFile.initialize(); // สำคัญมาก
      final data = await rootBundle.load(assetPath);
      _file = RiveFile.import(data);
      print("RiveCache: Successfully loaded Rive file!");
    } catch (e) {
      print("RiveCache: Error loading file: $e");
    } finally {
      _isLoading = false;
    }
  }

  RiveFile? get file => _file;
  bool get isLoaded => _file != null;
}