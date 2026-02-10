import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/right_side_menu.dart';
import '../widgets/custom_top_bar.dart';
import '../api_service.dart';

class LobbyScreen extends StatefulWidget {
  final User? user;
  
  const LobbyScreen({Key? key, this.user}) : super(key: key);

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  int _selectedIndex = 1; // Default to Lobby (Room)

  // Right Menu Items
  List<MenuItem> get _menuItems => [
    MenuItem(
      imagePath: "lib/assets/achievement_icon.png",
      label: 'ความสำเร็จ',
      onTap: () {
        Navigator.pushNamed(context, '/achievement');
      },
    ),
    MenuItem(
      imagePath: "lib/assets/quest_icon.png",
      label: 'ภารกิจ',
      onTap: () {
        Navigator.pushNamed(context, '/quest');
      },
    ),
    MenuItem(
      imagePath: "lib/assets/Gasha.png",
      label: 'กล่องสุ่ม',
      onTap: () {
        Navigator.pushNamed(context, '/lootbox');
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/Lobby.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar - ใช้ CustomTopBar
              CustomTopBar(
                user: widget.user,
                onNotificationTapped: () {
                  Navigator.pushNamed(context, '/notification');
                },
                onSettingsTapped: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),

              // Main Content
              Expanded(
                child: Stack(
                  children: [
                    // Right Side Menu Component
                    RightSideMenu(menuItems: _menuItems),
                  ],
                ),
              ),

              // Bottom Navigation
              CustomBottomNavigationBar(
                selectedIndex: _selectedIndex,
                onItemTapped: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                avatarUrl: null,
                playerLevel: widget.user?.level ?? 1,

                // Navigation callbacks
                onAvatarTapped: () {
                  Navigator.pushNamed(context, '/profile');
                },
                onFashionTapped: () {
                  Navigator.pushNamed(context, '/fashion');
                },
                onRoomTapped: () {
                  Navigator.pushNamed(context, '/lobby');
                },
                onMapTapped: () {
                  Navigator.pushNamed(context, '/map');
                },
                onClubTapped: () {
                  Navigator.pushNamed(context, '/club');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}