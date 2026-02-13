import 'package:flutter/material.dart';
<<<<<<< HEAD

import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/register.dart';
import 'package:flutter_application_1/screens/forgotpw.dart';
import 'package:flutter_application_1/screens/resetpw.dart';
import 'package:flutter_application_1/screens/setting_login.dart';
import 'package:flutter_application_1/screens/setting_logout.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
=======
import 'login.dart';
import 'register.dart';
import 'forgotpw.dart';
import 'resetpw.dart';
import 'setting_login.dart';
import 'setting_logout.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bgSetting.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 24, right: 24, bottom: 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.82),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFAAD7EA),
                  width: 3,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
<<<<<<< HEAD
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
=======
                            MaterialPageRoute(builder: (context) => const LoginPage()),
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          );
                        },
                        child: Text(
                          "หน้าเข้าสู่ระบบ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
<<<<<<< HEAD
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
=======
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          );
                        },
                        child: Text(
                          "หน้าสร้างบัญชี",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
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
                          "หน้าลืมรหัสผ่าน(OTP)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
<<<<<<< HEAD
                            MaterialPageRoute(builder: (context) => const ResetPWScreen()),
=======
                            MaterialPageRoute(builder: (context) => const ResetPWPage()),
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          );
                        },
                        child: Text(
                          "หน้ารีเซ็ตรหัสผ่าน",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
<<<<<<< HEAD
                            MaterialPageRoute(builder: (context) => const SettingLoginScreen()),
=======
                            MaterialPageRoute(builder: (context) => const SettingLoginPage()),
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          );
                        },
                        child: Text(
                          "หน้าตั้งค่า-login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
<<<<<<< HEAD
                            MaterialPageRoute(builder: (context) => const SettingLogoutScreen()),
=======
                            MaterialPageRoute(builder: (context) => const SettingLogoutPage()),
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                          );
                        },
                        child: Text(
                          "หน้าตั้งค่า-logout",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                       SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE94444),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 3,
                            ),
                            child: Text(
                              "ออกจากระบบ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ), 
              ),
            ),
          ),

        ],
      ),
    );
  }
}
