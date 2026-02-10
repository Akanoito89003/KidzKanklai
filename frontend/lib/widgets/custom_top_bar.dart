import 'package:flutter/material.dart';
import '../api_service.dart';

class CustomTopBar extends StatelessWidget {
  final User? user;
  final VoidCallback? onNotificationTapped;
  final VoidCallback? onSettingsTapped;

  const CustomTopBar({
    Key? key,
    this.user,
    this.onNotificationTapped,
    this.onSettingsTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: Row(
        children: [
          // กรอบหลักที่มี coins, tickets, vouchers
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTopBarItem(
                    imagePath: 'lib/assets/coin.png',
                    value: '${user?.coins ?? 0}',
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.grey[300],
                  ),
                  _buildTopBarItem(
                    imagePath: 'lib/assets/Ticket-ภารกิจ_img.png',
                    value: '${user?.tickets ?? 0}/7',
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.grey[300],
                  ),
                  _buildTopBarItem(
                    imagePath: 'lib/assets/Ticket-เข้าสอบ_img.png',
                    value: '${user?.vouchers ?? 0}/3',
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 8),

          // Notification Button (นอกกรอบ)
          _buildTopBarIconButton(
            imagePath: 'lib/assets/notification_icon.png',
            onTap: () {
              if (onNotificationTapped != null) {
                onNotificationTapped!();
              } else {
                Navigator.pushNamed(context, '/notification');
              }
            },
          ),

          SizedBox(width: 8),

          // Settings Button (นอกกรอบ)
          _buildTopBarIconButton(
            imagePath: 'lib/assets/setting_icon.png',
            onTap: () {
              if (onSettingsTapped != null) {
                onSettingsTapped!();
              } else {
                Navigator.pushNamed(context, '/settings');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopBarItem({
    required String imagePath,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 20,
            height: 20,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.image_not_supported,
                size: 20,
                color: Colors.grey,
              );
            },
          ),
          SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBarIconButton({
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF59ABEC), Color(0xFF93C8D0)],
          ),
          border: Border.all(color: Color(0xFF114575), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Image.asset(
          imagePath,
          width: 18,
          height: 18,
          fit: BoxFit.contain,
          color: Color(0xFF002A50),
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.settings,
              size: 25,
              color: Color(0xFF002A50),
            );
          },
        ),
      ),
    );
  }
}