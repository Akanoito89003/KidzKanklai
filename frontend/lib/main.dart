import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/forgotpw.dart';
import 'screens/resetpw.dart';
import 'screens/lobby.dart';
import 'screens/fashion_screen.dart';
import 'screens/quest_screen.dart';
import 'screens/countdown_screen.dart';
import 'screens/profile.dart';
import 'screens/notification.dart';
import 'screens/achievement.dart';
import 'screens/lootbox_screen.dart';
import 'screens/map_screen.dart';
import 'screens/club_screen.dart';
import 'screens/setting_login.dart';
import 'screens/setting_logout.dart';
import 'screens/startgame.dart';
import 'screens/loading.dart';
import 'screens/test.dart';

void main() {
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
      initialRoute: '/lobby',
      routes: {
        '/test': (context) => const TestScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgotpw': (context) => const ForgotPWScreen(),
        '/resetpw': (context) => const ResetPWScreen(),
        '/lobby': (context) => LobbyScreen(),
        '/fashion': (context) => FashionScreen(user: User(id: 0, username: "Guest", email: "", level: 1, exp: 0, coins: 0, tickets: 0, vouchers: 0, bio: "", soundBGM: 50, soundSFX: 50, equippedSkin: "", equippedHair: "", equippedFace: "", statIntellect: 0, statStrength: 0, statCreativity: 0)),
        '/quest': (context) => const QuestScreen(),
        '/countdown': (context) => const CountdownScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/achievement': (context) => const AchievementScreen(),
        '/lootbox': (context) => const LootboxScreen(),
        '/map': (context) => const MapScreen(),
        '/club': (context) => const ClubScreen(),
        '/startgame': (context) => const StartGameScreen(),
        '/load': (context) => const LoadingScreen(),
      },
    );
  }
}
