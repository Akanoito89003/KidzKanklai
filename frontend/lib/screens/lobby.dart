import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_service.dart';

import 'package:flutter_application_1/widgets/bottom_navigation_bar.dart';
import 'package:flutter_application_1/widgets/right_side_menu.dart';
import 'package:flutter_application_1/widgets/custom_top_bar.dart';
import 'package:flutter_application_1/widgets/character_widget.dart';

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
      imagePath: "assets/images/icon/iconAchievement.png",
      label: 'ความสำเร็จ',
      onTap: () {
        Navigator.pushNamed(context, '/achievement');
      },
    ),
    MenuItem(
      imagePath: "assets/images/icon/iconQuest.png",
      label: 'ภารกิจ',
      onTap: () {
        Navigator.pushNamed(context, '/createnormalquest');
      },
    ),
    MenuItem(
      imagePath: "assets/images/item/Gasha.png",
      label: 'กล่องสุ่ม',
      onTap: () {
        Navigator.pushNamed(context, '/gasha');
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background/bg3.png"),
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
                  Navigator.pushNamed(context, '/setting');
                },
              ),

              // Main Content
              // Main Content
              Expanded( // Added Expanded to fill remaining space
                child: Stack(
                  alignment: Alignment.center, // Center the character
                  children: [
                    // Character Widget - อยู่ชั้นล่างสุด
                    Positioned(
                      bottom: -50, // Adjust position as needed
                      child: CharacterWidget(
                        height: 600, 
                        width: 500,
                        user: widget.user, // Pass User
                      ),
                    ),

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