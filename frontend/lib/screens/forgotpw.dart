import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_application_1/screens/register.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/resetpw.dart'; 

class ForgotPWScreen extends StatefulWidget {
  const ForgotPWScreen({super.key});

  @override
  State<ForgotPWScreen> createState() => _ForgotPWScreenState();
}

class _ForgotPWScreenState extends State<ForgotPWScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  
  // เพิ่มตัวแปรสำหรับ Loading
  bool _isLoading = false; 
  // เรียก instance ของ Supabase
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    // --- ส่วนที่เพิ่ม: ดักจับตอน User กดลิงก์จากอีเมลกลับมา ---
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.passwordRecovery) {
        // เมื่อเป็นเหตุการณ์กู้คืนรหัสผ่าน ให้ไปหน้าตั้งรหัสใหม่
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ResetPWScreen()),
          );
        }
      }
    });
  }
=======
import 'register.dart';
import 'login.dart';

class ForgotPWPage extends StatefulWidget {
  const ForgotPWPage({super.key});

  @override
  State<ForgotPWPage> createState() => _ForgotPWPageState();
}

class _ForgotPWPageState extends State<ForgotPWPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  // --- ฟังก์ชันส่งอีเมล ---
  Future<void> _handleResetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอกอีเมล")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutter://reset-callback', // **ต้องตรงกับ AndroidManifest**
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("ส่งลิงก์รีเซ็ตไปที่อีเมลแล้ว กรุณาตรวจสอบ Inbox/Junk"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("เกิดข้อผิดพลาดที่ไม่ทราบสาเหตุ"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define colors relative to the design (conceptual)
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
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bgRegister.png',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay for readability
          Positioned.fill(
<<<<<<< HEAD
            child: Container(
=======
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
          // Content
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

>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                  // Login Card
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
                          // Logo
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Image.asset(
                              'assets/images/logo.png',
<<<<<<< HEAD
                              height: 100,
=======
                              height: 100, 
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 20),
<<<<<<< HEAD
                          const Text(
=======
                          Text(
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                            "ลืมรหัสผ่าน",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 32),
<<<<<<< HEAD

=======
                          
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          // Email Input
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
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

                          // OTP Input (คงไว้ตาม UI เดิม แต่ไม่ได้ใช้ Logic OTP)
=======
                          
                          // OTP Input
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          TextField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: "รหัส OTP",
                              prefixIcon: Icon(Icons.lock_clock, color: primaryColor),
                              suffixIcon: SizedBox(
                                height: 60, // Ensure it fills height
                                child: ElevatedButton(
                                  onPressed: () {
<<<<<<< HEAD
                                    // แค่เปลี่ยน UI state ตามเดิม ไม่ยิง API
=======
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                                    if (!_isOtpSent) {
                                      setState(() {
                                        _isOtpSent = true;
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isOtpSent ? Colors.white : Colors.black,
                                    foregroundColor: _isOtpSent ? const Color(0xFF828587) : Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
<<<<<<< HEAD
                                      side: _isOtpSent
                                          ? const BorderSide(color: Color(0xFFCED4DA))
                                          : BorderSide.none,
                                    ),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
=======
                                      side: _isOtpSent 
                                          ? const BorderSide(color: Color(0xFFCED4DA)) 
                                          : BorderSide.none,
                                    ),
                                    // Remove minimum size constraints to allow fitting
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                                    "ขอรหัส",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
<<<<<<< HEAD
                          
=======
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          if (_isOtpSent) ...[
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isOtpSent = false;
                                  });
                                },
                                child: Text(
                                  "ยังไม่ได้รับรหัสใช่ไหม?",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 32),
<<<<<<< HEAD

                          // Reset Password Button (ปุ่มหลักในการส่งอีเมล)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              // แก้ไข: เรียกฟังก์ชัน _handleResetPassword เมื่อกดปุ่ม
                              onPressed: _isLoading ? null : _handleResetPassword,
=======
                          
                          // Reset Password Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle Reset Password / OTP Verification
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
                              child: _isLoading 
                                ? const SizedBox(
                                    height: 20, 
                                    width: 20, 
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                  )
                                : const Text(
                                    "รีเซ็ตรหัสผ่าน",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
=======
                              child: Text(
                                "รีเซ็ตรหัสผ่าน",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
<<<<<<< HEAD

                  const SizedBox(height: 30),

                  // Sign Up & Back to Login
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
                      const SizedBox(width: 15),
<<<<<<< HEAD
                      const Text(
=======
                      // Divider
                      Text(
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                        "|",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 15),
<<<<<<< HEAD
=======
                      // Back to Login
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
<<<<<<< HEAD
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text(
=======
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: Text(
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          "กลับไปหน้าเข้าสู่ระบบ",
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
<<<<<<< HEAD
}
=======
}

>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
