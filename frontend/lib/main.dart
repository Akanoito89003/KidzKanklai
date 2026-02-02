import 'package:flutter/material.dart';
// import 'api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/forgotpw.dart';
import 'screens/resetpw.dart';
// import 'screens/lobby_screen.dart';
// import 'screens/fashion_screen.dart';
// import 'screens/settings_screen.dart';
import 'screens/quest_screen.dart';
import 'screens/countdown_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/achievement_screen.dart';
import 'screens/lootbox_screen.dart';
import 'screens/map_screen.dart';
import 'screens/club_screen.dart';
import 'screens/test.dart';

import 'screens/me.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dregaeeryyqlfssejzbr.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRyZWdhZWVyeXlxbGZzc2VqemJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg0NjAzMzgsImV4cCI6MjA4NDAzNjMzOH0.QEyCrkki7K-RgaejMTdYsx-N-dt87Qi1LjJSZ4VFNLw',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce, // 🔥 สำคัญสำหรับ Google OAuth
    ),
  );

  runApp(const KidzKanklaiApp());
}

class KidzKanklaiApp extends StatelessWidget {
  const KidzKanklaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KidzKanklai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.kanitTextTheme(),
        useMaterial3: true,
      ),

      // ✅ ใช้ AuthGate เป็นหน้าแรก
      home: const AuthGate(),
      
      routes: {

        '/me': (context) => const MePage(),

        '/test': (context) => const TestPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgotpw': (context) => const ForgotPWPage(),
        '/resetpw': (context) => const ResetPWPage(),
        // '/lobby': (context) => LobbyScreen(user: User(id: 0, username: "Guest", email: "", level: 1, exp: 0, coins: 0, tickets: 0, vouchers: 0, bio: "", soundBGM: 50, soundSFX: 50, equippedSkin: "", equippedHair: "", equippedFace: "", statIntellect: 0, statStrength: 0, statCreativity: 0)),
        // '/fashion': (context) => FashionScreen(user: User(id: 0, username: "Guest", email: "", level: 1, exp: 0, coins: 0, tickets: 0, vouchers: 0, bio: "", soundBGM: 50, soundSFX: 50, equippedSkin: "", equippedHair: "", equippedFace: "", statIntellect: 0, statStrength: 0, statCreativity: 0)),
        // '/settings': (context) => SettingsScreen(user: User(id: 0, username: "Guest", email: "", level: 1, exp: 0, coins: 0, tickets: 0, vouchers: 0, bio: "", soundBGM: 50, soundSFX: 50, equippedSkin: "", equippedHair: "", equippedFace: "", statIntellect: 0, statStrength: 0, statCreativity: 0)),
        '/quest': (context) => const QuestScreen(),
        '/countdown': (context) => const CountdownScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/achievement': (context) => const AchievementScreen(),
        '/lootbox': (context) => const LootboxScreen(),
        '/map': (context) => const MapScreen(),
        '/club': (context) => const ClubScreen(),
      },
    );
  }
}

/// 🔐 ตัวคุมว่า login แล้วหรือยัง
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;

        if (session != null) {
          // ✅ login แล้ว
          return const MePage();
        } else {
          // ❌ ยังไม่ login
          return const LoginPage();
        }
      },
    );
  }
}
