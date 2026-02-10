import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define colors relative to the design (conceptual)
    final primaryColor = const Color(0xFF556AEB); 
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
             child: Container(
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
                  // Logo
                  // Logo moved inside card

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
                              height: 100, 
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 20),
                          Text(
                            "ลืมรหัสผ่าน",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
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
                          
                          // OTP Input
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
                                      side: _isOtpSent 
                                          ? const BorderSide(color: Color(0xFFCED4DA)) 
                                          : BorderSide.none,
                                    ),
                                    // Remove minimum size constraints to allow fitting
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
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
                          
                          // Reset Password Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle Reset Password / OTP Verification
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
                                "รีเซ็ตรหัสผ่าน",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: Text(
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
                      // Divider
                      Text(
                        "|",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Back to Login
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: Text(
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
}

