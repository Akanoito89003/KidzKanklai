import 'package:flutter/material.dart';

class MenuItem {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  MenuItem({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });
}

class RightSideMenu extends StatelessWidget {
  final List<MenuItem> menuItems;

  const RightSideMenu({
    Key? key,
    required this.menuItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      top: 20,
      child: Column(
        children: menuItems.map((item) => _buildMenuItem(item)).toList(),
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            // รูปภาพ (ไม่มีกล่อง)
            Image.asset(
              item.imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // ถ้ารูปโหลดไม่ได้ แสดง Icon แทน
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.image_not_supported,
                    size: 30,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            
            SizedBox(height: 4),
            
            // ข้อความ
            Text(
              item.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5D4037),
                shadows: [
                  Shadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}