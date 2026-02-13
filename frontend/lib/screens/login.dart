import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_application_1/screens/register.dart';
import 'package:flutter_application_1/screens/forgotpw.dart';
import 'package:flutter_application_1/screens/profile.dart';
import 'package:flutter_application_1/screens/lobby.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
=======
import 'register.dart';
import 'forgotpw.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

<<<<<<< HEAD
  late final Stream<AuthState> _authStream;

  @override
  void initState() {
    super.initState();

    // 👇 ฟังการเปลี่ยนแปลงสถานะ login (สำคัญสำหรับ Google OAuth)
    _authStream = Supabase.instance.client.auth.onAuthStateChange;

    _authStream.listen((data) {
      final session = data.session;
      if (session != null && mounted) {
        Navigator.pushReplacementNamed(context, '/lobby');
      }
    });
  }

=======
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  /// 🔐 Login ด้วย Email/Password
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกอีเมลและรหัสผ่าน')),
      );
      return;
    }

    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เข้าสู่ระบบสำเร็จ')),
        );

        Navigator.pushReplacementNamed(context, '/lobby');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  /// 🔑 Login ด้วย Google
  Future<void> _loginWithGoogle() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF556AEB);
=======
  @override
  Widget build(BuildContext context) {
    // Define colors relative to the design (conceptual)
    final primaryColor = const Color(0xFF556AEB); 
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
    final backgroundColor = Colors.white;

    return Scaffold(
      body: Stack(
        children: [
<<<<<<< HEAD
=======
          // Background Image
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
          Positioned.fill(
            child: Image.asset(
              'assets/images/bgRegister.png',
              fit: BoxFit.cover,
            ),
          ),
<<<<<<< HEAD
          Positioned.fill(
            child: Container(
=======
          // Gradient Overlay for readability
          Positioned.fill(
             child: Container(
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ),
<<<<<<< HEAD
=======
          // Content
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
<<<<<<< HEAD
=======
                  // Logo
                  // Logo moved inside card

                  // Login Card
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: backgroundColor.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
<<<<<<< HEAD
=======
                          // Logo
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Image.asset(
                              'assets/images/logo.png',
<<<<<<< HEAD
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const Text(
                            "ยินดีต้อนรับกลับสู่ห้องเรียน",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          const Text(
=======
                              height: 100, 
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            "ยินดีต้อนรับกลับสู่ห้องเรียน",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                            "เข้าสู่ระบบ",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 32),
<<<<<<< HEAD

=======
                          
                          // Email Input
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "อีเมล",
                              prefixIcon: Icon(Icons.email, color: primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 16),
<<<<<<< HEAD

=======
                          
                          // Password Input
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: "รหัสผ่าน",
                              prefixIcon: Icon(Icons.lock, color: primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 10),
<<<<<<< HEAD

=======
                          
                          // Forgot Password
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
<<<<<<< HEAD
                                  MaterialPageRoute(builder: (context) => const ForgotPWScreen()),
=======
                                  MaterialPageRoute(builder: (context) => const ForgotPWPage()),
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                                );
                              },
                              child: Text(
                                "ลืมรหัสผ่านใช่ไหม?",
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
<<<<<<< HEAD

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
=======
                          
                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle Login
                              },
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                elevation: 3,
                              ),
<<<<<<< HEAD
                              child: const Text(
                                "เข้าสู่ระบบ",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
=======
                              child: Text(
                                "เข้าสู่ระบบ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
<<<<<<< HEAD

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loginWithGoogle,
=======
                          // Google Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle Google Login
                              },
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                elevation: 3,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/IconGoogle.png',
                                    height: 36,
                                    width: 36,
                                  ),
                                  const SizedBox(width: 12),
<<<<<<< HEAD
                                  const Text(
                                    "เข้าสู่ระบบผ่าน Google",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
=======
                                  Text(
                                    "เข้าสู่ระบบผ่าน Google",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
<<<<<<< HEAD

                  const SizedBox(height: 30),

=======
                  
                  const SizedBox(height: 30),
                  
                  // Sign Up
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
<<<<<<< HEAD
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text(
=======
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: Text(
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          "สร้างบัญชีใหม่",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
<<<<<<< HEAD
=======

>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
