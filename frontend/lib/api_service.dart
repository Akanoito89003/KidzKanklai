import 'dart:convert';
import 'package:http/http.dart' as http;

// --- Data Models ---

class User {
  final int id;
  final String username;
  final String email;
  final int level;
  final int exp;
  final int coins;
  final int tickets;
  final int vouchers;
  final String bio;
  final int soundBGM;
  final int soundSFX;
  final String equippedSkin;
  final String equippedHair;
  final String equippedFace;
  final int statIntellect;
  final int statStrength;
  final int statCreativity;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.level,
    required this.exp,
    required this.coins,
    required this.tickets,
    required this.vouchers,
    required this.bio,
    required this.soundBGM,
    required this.soundSFX,
    required this.equippedSkin,
    required this.equippedHair,
    required this.equippedFace,
    required this.statIntellect,
    required this.statStrength,
    required this.statCreativity,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      level: json['level'] ?? 1,
      exp: json['exp'] ?? 0,
      coins: json['coins'] ?? 0,
      tickets: json['tickets'] ?? 0,
      vouchers: json['vouchers'] ?? 0,
      bio: json['bio'] ?? '',
      soundBGM: json['sound_bgm'] ?? 70,
      soundSFX: json['sound_sfx'] ?? 70,
      equippedSkin: json['equipped_skin'] ?? '',
      equippedHair: json['equipped_hair'] ?? '',
      equippedFace: json['equipped_face'] ?? '',
      statIntellect: json['stat_intellect'] ?? 0,
      statStrength: json['stat_strength'] ?? 0,
      statCreativity: json['stat_creativity'] ?? 0,
    );
  }
}

class InventoryItem {
  final String type;
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final int riveId;
  
  InventoryItem({
    required this.type, 
    required this.id,
    this.name = '',
    this.category = '',
    this.imagePath = '',
    this.riveId = 0,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      type: json['type'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      imagePath: json['image_path'] ?? '',
      riveId: json['rive_id'] ?? 0,
    );
  }
}

// --- API Service ---

class ApiService {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
  static const String baseUrl = "http://10.0.2.2:8080";

  // Auth
  static Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        // Login returns basic info, might want to fetch full profile after
        return User.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Login Error: $e");
    }
    return null;
  }

  static Future<bool> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print("Register Error: $e");
      return false;
    }
  }

  // Profile
  static Future<User?> getProfile(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/me/$userId'));
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("Get Profile Error: $e");
    }
    return null;
  }

  // Inventory
  static Future<List<InventoryItem>> getInventory(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/inventory/$userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['items'] as List;
        return list.map((e) => InventoryItem.fromJson(e)).toList();
      }
    } catch (e) {
      print("Get Inventory Error: $e");
    }
    return [];
  }

  // Equip
  static Future<bool> equipItem(int userId, String type, String itemId) async {
     try {
      final response = await http.post(
        Uri.parse('$baseUrl/equip'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "type": type,
          "item_id": itemId
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Equip Error: $e");
      return false;
    }
  }
}
