import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_application_1/screens/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
=======
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  // ====== LOGIC สมัครสมาชิก ======
  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบ')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')),
      );
      return;
    }

    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );

      if (res.session != null && mounted) {
        Navigator.pushReplacementNamed(context, '/lobby');
      } else {
        await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/lobby');
        }
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  // ====== LOGIC Google ======
  Future<void> _registerWithGoogle() async {
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
    // Define colors relative to the design
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
                  // Register Card
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: backgroundColor.withOpacity(0.95),
                    child: Padding(
<<<<<<< HEAD
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 100,
                          ),
                          const SizedBox(height: 10),
                          const Text("สวัสดีสมาชิกใหม่!",
                              style: TextStyle(color: Colors.black)),
                          const SizedBox(height: 10),
                          const Text("ลงทะเบียน",
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),

                          // Name
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: "ชื่อผู้ใช้งาน",
                              prefixIcon:
                                  Icon(Icons.person, color: primaryColor),
=======
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 100, 
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(
                            "สวัสดีสมาชิกใหม่!",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "ลงทะเบียน",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Name Input
                          TextField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "ชื่อผู้ใช้งาน",
                              prefixIcon: Icon(Icons.person, color: primaryColor),
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
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
                          // Email
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "อีเมล",
                              prefixIcon:
                                  Icon(Icons.email, color: primaryColor),
=======
                          // Email Input
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "อีเมล",
                              prefixIcon: Icon(Icons.email, color: primaryColor),
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
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

                          // Password
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: "รหัสผ่าน",
                              prefixIcon:
                                  Icon(Icons.lock, color: primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
=======
                          
                          // Password Input
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "รหัสผ่าน",
                              prefixIcon: Icon(Icons.lock, color: primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
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
                          const SizedBox(height: 16),

<<<<<<< HEAD
                          // Confirm Password
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              labelText: "ยืนยันรหัสผ่าน",
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
=======
                          // Confirm Password Input
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: "ยืนยันรหัสผ่าน",
                              prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
<<<<<<< HEAD
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
=======
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
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
                          const SizedBox(height: 24),
<<<<<<< HEAD

=======
                          
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
<<<<<<< HEAD
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: const Text(
                                "ลงทะเบียน",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
=======
                              onPressed: () {
                                // Handle Register
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                elevation: 3,
                              ),
                              child: Text(
                                "ลงทะเบียน",
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

                          // Google Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _registerWithGoogle,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
=======
                          // Google Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle Google Login
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                elevation: 3,
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
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
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "มีบัญชีอยู่แล้ว",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
=======
                  
                  const SizedBox(height: 30),
                  
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: Text(
                          "มีบัญชีอยู่แล้ว",
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
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
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
