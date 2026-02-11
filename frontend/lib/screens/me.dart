import 'dart:convert'; // [ADDED] สำหรับแปลง JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // [ADDED] สำหรับยิง API
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_application_1/screens/profile.dart';
import 'package:flutter_application_1/screens/setting.dart';
import 'package:flutter_application_1/config/app_config.dart'; // [ADDED] สำหรับดึง baseUrl

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  String localEmail = 'Loading...';
  String backendResponse = 'Waiting for server...'; // เก็บผลลัพธ์จาก Go
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMeFromGo(); // เรียกทำงานทันทีที่เข้าหน้า
  }

  // ฟังก์ชันยิงไปหา Golang
  Future<void> _fetchMeFromGo() async {
    setState(() => isLoading = true);

    try {
      // 1. ดึง Token ปัจจุบันจาก Supabase ในเครื่อง
      final session = Supabase.instance.client.auth.currentSession;
      final token = session?.accessToken;
      final user = Supabase.instance.client.auth.currentUser;

      // อัปเดตอีเมลฝั่ง Local
      setState(() {
        localEmail = user?.email ?? 'No User';
      });

      if (token == null) {
        setState(() => backendResponse = "Error: No logged in session.");
        return;
      }

      // 2. กำหนด URL ของ Golang Server
      // Android Emulator ใช้ 10.0.2.2 แทน localhost
      // iOS Simulator ใช้ localhost ได้เลย
      final url = Uri.parse('${AppConfig.baseUrl}/me'); 

      print("Sending request to: $url");
      print("Token: Bearer ${token.substring(0, 10)}..."); // Debug ดู Token ย่อๆ

      // 3. ยิง Request พร้อมแนบ Header
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // สำคัญมาก! ต้องมี
          'Content-Type': 'application/json',
        },
      );

      // 4. แสดงผลลัพธ์
      if (response.statusCode == 200) {
        // ถ้าสำเร็จ Go จะส่ง JSON กลับมา
        final data = jsonDecode(response.body);
        setState(() {
          backendResponse = "✅ Success from Go:\n"
              "ID: ${data['id']}\n"
              "Email: ${data['email']}";
        });
      } else {
        setState(() {
          backendResponse = "❌ Server Error (${response.statusCode}):\n${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        backendResponse = "❌ Connection Error:\n$e";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Test'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchMeFromGo, // ปุ่มกดทดสอบใหม่
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.developer_board, size: 80, color: Colors.blueGrey),
              const SizedBox(height: 20),

              const Text('Local Supabase Data:', style: TextStyle(color: Colors.grey)),
              Text(localEmail, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

              const Divider(height: 40),

              const Text('Golang Backend Response:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 10),
              
              // กล่องแสดงผลจาก Server
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : Text(
                        backendResponse,
                        style: TextStyle(
                          fontFamily: 'Courier', // ฟอนต์แบบ Code
                          color: backendResponse.startsWith('✅') ? Colors.green[800] : Colors.red[800],
                        ),
                      ),
              ),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                icon: const Icon(Icons.person),
                label: const Text('Go to Profile Page'),
              ),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingScreen()),
                  );
                },
                icon: const Icon(Icons.settings),
                label: const Text('Go to Setting Page'),
              ),
              
              const SizedBox(height: 10),

              TextButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}