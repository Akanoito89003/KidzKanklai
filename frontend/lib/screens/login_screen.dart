import 'package:flutter/material.dart';
import '../api_service.dart';
import 'lobby_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: "test@example.com");
  final _passCtrl = TextEditingController(text: "password123");
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    setState(() => _isLoading = true);
    final user = await ApiService.login(_emailCtrl.text, _passCtrl.text);
    setState(() => _isLoading = false);

    if (user != null) {
      if (mounted) {
        // Pass the user object to Lobby
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LobbyScreen(user: user)),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("เข้าสู่ระบบไม่สำเร็จ: โปรดตรวจสอบอีเมลหรือรหัสผ่าน")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1623835626927-444f62771805?q=80&w=1968&auto=format&fit=crop'), // Background placeholder
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo Placeholder
                    const Icon(Icons.school, size: 60, color: Colors.green),
                    const Text(
                      "Kidz\nKanKlai",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cursive', // Placeholder font
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "ยินดีต้อนรับกลับสู่ห้องเรียน!",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "เข้าสู่ระบบ",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 30),
                    
                    // Email Field
                    Align(alignment: Alignment.centerLeft, child: Text("อีเมล", style: TextStyle(color: Colors.grey.shade700))),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                        hintText: "อีเมล",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    Align(alignment: Alignment.centerLeft, child: Text("รหัสผ่าน", style: TextStyle(color: Colors.grey.shade700))),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _passCtrl,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "******",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Login Button
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C6BC0), // Purple/Blue tone
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            elevation: 2,
                          ),
                          child: const Text("เข้าสู่ระบบ", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    
                    const SizedBox(height: 15),
                    // Google Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Google Login Coming Soon!")));
                        },
                        icon: const Icon(Icons.login, color: Colors.white), // Should be Google logo
                        label: const Text("เข้าสู่ระบบผ่าน Google", style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/register'),
                          child: const Text("สร้างบัญชีใหม่", style: TextStyle(color: Colors.grey)),
                        ),
                         TextButton(
                          onPressed: () {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reset Password Coming Soon!")));
                          },
                          child: const Text("ลืมรหัสผ่านใช่ไหม?", style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
