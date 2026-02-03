import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/custom_top_bar.dart';
import '../api_service.dart';

class AchievementScreen extends StatefulWidget {
  final User? user;
  const AchievementScreen({Key? key, this.user}) : super(key: key);

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            _buildTopBar(),

            // Main Content
            Expanded(
              child: Stack(children: [Center(child: Text('Achievement Page'))]),
            ),

            // Bottom Navigation
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

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 75,
            color: Colors.black.withOpacity(0.4),
            child: CustomTopBar(
              user: widget.user,
              onNotificationTapped: () {
                Navigator.pushNamed(context, '/notification');
              },
              onSettingsTapped: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ),
        ],
      ),
    );
  }
}