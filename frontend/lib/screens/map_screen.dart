import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/right_side_menu.dart';
import '../widgets/custom_top_bar.dart';
import '../api_service.dart';

class MapScreen extends StatefulWidget {
  final User? user;

  const MapScreen({super.key, this.user});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedIndex = 2; // Map = index 2

  final List<String> _menuItems = [
    'ภารกิจ',
    'ร้านค้า',
    'เพื่อน',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Top Bar
            CustomTopBar(
              user: widget.user,
              onNotificationTapped: () {
                Navigator.pushNamed(context, '/notification');
              },
              onSettingsTapped: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),

            // ✅ Main Content
            Expanded(
              child: Stack(
                children: [
                  Center(child: Text('Map Page')),
                  
                ],
              ),
            ),

            // ✅ Bottom Navigation
            CustomBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() {
                  _selectedIndex = index;
                });

                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, '/fashion');
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/lobby');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/map');
                    break;
                  case 3:
                    Navigator.pushNamed(context, '/club');
                    break;
                }
              },
              avatarUrl: null,
              playerLevel: widget.user?.level ?? 1,
              onAvatarTapped: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}
