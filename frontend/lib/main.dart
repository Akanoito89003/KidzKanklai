import 'package:flutter/material.dart';
import 'api_service.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/lobby_screen.dart';
import 'screens/fashion_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/quest_screen.dart';
import 'screens/countdown_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/achievement_screen.dart';
import 'screens/lootbox_screen.dart';
import 'screens/map_screen.dart';
import 'screens/club_screen.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';

import 'package:flutter/services.dart';
import 'utils/rive_cache.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-load the heavy 5MB Rive file
  // Pre-load the heavy 5MB Rive file (Fire and forget, don't await)
  RiveCache().loadAsset('assets/animation/Model1110.riv').then((_) {
     print("Main: Rive Preload Complete.");
  }).catchError((e) {
     print("Main: Rive Preload Failed: $e");
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const KidzKanklaiApp(),
    ),
  );
}

class KidzKanklaiApp extends StatelessWidget {
  const KidzKanklaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KidzKanklai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      initialRoute: '/lobby', // Bypass Login for Dev
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/lobby': (context) => LobbyScreen(user: User(id: 1, username: "Tester", email: "test@example.com", level: 5, exp: 500, coins: 1000, tickets: 10, vouchers: 5, bio: "", soundBGM: 50, soundSFX: 50, equippedSkin: "basic_uniform", equippedHair: "default_blue", equippedFace: "happy", statIntellect: 0, statStrength: 0, statCreativity: 0, equippedPose: 0)),
        '/fashion': (context) => FashionScreen(user: User(id: 1, username: "Tester", email: "test@example.com", level: 5, exp: 500, coins: 1000, tickets: 10, vouchers: 5, bio: "", soundBGM: 50, soundSFX: 50, equippedSkin: "basic_uniform", equippedHair: "default_blue", equippedFace: "happy", statIntellect: 0, statStrength: 0, statCreativity: 0, equippedPose: 0)),
        '/settings': (context) => SettingsScreen(user: User(id: 1, username: "Tester", email: "test@example.com", level: 5, exp: 500, coins: 1000, tickets: 10, vouchers: 5, bio: "", soundBGM: 50, soundSFX: 50, equippedSkin: "basic_uniform", equippedHair: "default_blue", equippedFace: "happy", statIntellect: 0, statStrength: 0, statCreativity: 0, equippedPose: 0)),
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
