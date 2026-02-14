import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveCache {
  static final RiveCache _instance = RiveCache._internal();
  factory RiveCache() => _instance;
  RiveCache._internal();

  RiveFile? _file;
  bool _isLoading = false;

  Future<void> loadAsset(String assetPath) async {
    if (_file != null) return; // Already loaded
    if (_isLoading) return; // Loading in progress

    _isLoading = true;
    try {
      print("RiveCache: Start loading $assetPath...");
      
      // Initialize Rive Core (Critical for performance/bindings)
      await RiveFile.initialize();
      
      final data = await rootBundle.load(assetPath);
      // RiveFile.import parses the binary. For 5MB this is heavy.
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
