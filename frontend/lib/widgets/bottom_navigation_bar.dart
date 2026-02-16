import 'package:flutter/material.dart';
import 'dart:math';

// Custom Painter สำหรับวงเลเวล
class LevelRingPainter extends CustomPainter {
  final double progress; // 0.0 - 1.0
  final Color color;
  final double strokeWidth;

  LevelRingPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // พื้นหลัง (สีเทาอ่อน)
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress (สีตาม level)
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.141592653589793 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.6 / 2, // เริ่มจากด้านล่าง
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final VoidCallback? onAvatarTapped;

  final VoidCallback? onFashionTapped;
  final VoidCallback? onRoomTapped;
  final VoidCallback? onMapTapped;
  final VoidCallback? onClubTapped;

  // Player data
  final String? avatarUrl;
  final int playerLevel;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.onAvatarTapped,
    this.onFashionTapped,
    this.onRoomTapped,
    this.onMapTapped,
    this.onClubTapped,
    this.avatarUrl,
    this.playerLevel = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110, // เพิ่มความสูงเพื่อรองรับโปรไฟล์ใหญ่
      child: Stack(
        children: [
          // BACKGROUND
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 65, // เพิ่มความสูงพื้นหลัง
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
            ),
          ),

          //STAR DECOR PICTURE
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset("assets/images/design/design-left.png"),
          ),

          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset("assets/images/design/design-right.png"),
          ),

          // Content button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(left: 8, right: 12, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Avatar ใหญ่ขึ้น
                  _buildAvatar(),

                  SizedBox(width: 8),

                  // Navigation Items
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2), // ยกปุ่มขึ้นนิดหน่อย
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            index: 0,
                            imagePath: "assets/images/icon/icon-fashion.png",
                            label: 'แฟชั่น',
                            onTap: onFashionTapped,
                          ),
                          _buildNavItem(
                            index: 1,
                            imagePath: "assets/images/icon/icon-room.png",
                            label: 'ห้องรับรอง',
                            onTap: onRoomTapped,
                          ),
                          _buildNavItem(
                            index: 2,
                            imagePath: "assets/images/icon/icon-map.png",
                            label: 'แผนที่',
                            onTap: onMapTapped,
                          ),
                          _buildNavItem(
                            index: 3,
                            imagePath: "assets/images/icon/icon-club.png",
                            label: 'ชมรม',
                            onTap: onClubTapped,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: () {
        if (onAvatarTapped != null) {
          onAvatarTapped!();
        }
      },
      child: Container(
        width: 85, // เพิ่มความกว้าง
        padding: EdgeInsets.only(bottom: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar + Level Ring + Badge
            SizedBox(
              width: 110, // เพิ่มขนาด
              height: 110,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // วงเลเวล (Progress Ring)
                  CustomPaint(
                    size: Size(85, 85),
                    painter: LevelRingPainter(
                      progress: (playerLevel % 10) / 10,
                      color: _getAvatarBorderColor(),
                      strokeWidth: 5, // เพิ่มความหนา
                    ),
                  ),

                  // รูป Avatar
                  Container(
                    width: 75, // เพิ่มขนาด
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200, width: 3),
                    ),
                    child: ClipOval(
                      child: avatarUrl != null
                          ? Image.network(
                              avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/profile/profile_img.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDefaultAvatar();
                                  },
                                );
                              },
                            )
                          : Image.asset(
                              'assets/images/profile/profile_img.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildDefaultAvatar();
                              },
                            ),
                    ),
                  ),

                  // Level Badge (ล่างขวา)
                  Positioned(
                    left: 55,
                    right: 0,
                    bottom: 6,
                    child: Container(
                      width: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xFFE4E4E4),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$playerLevel',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF313131),
                              height: 1.0,
                            ),
                          ),
                          Text(
                                'Lv.',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF313131),
                                  height: 0.9,
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF87CEEB), Color(0xFF4A90E2)],
        ),
      ),
      child: Icon(Icons.person, color: Colors.white, size: 40),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String imagePath,
    required String label,
    VoidCallback? onTap,
  }) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onItemTapped(index);
            if (onTap != null) {
              onTap();
            }
          },
          borderRadius: BorderRadius.circular(360),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56, // เพิ่มขนาดปุ่ม
                  height: 56,
                  padding: EdgeInsets.all(isSelected ? 4 : 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [Color(0xFF75C6EA), Color(0xFFCEFFB2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: !isSelected ? Colors.white.withOpacity(0.8) : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Color(0xFF000000).withOpacity(0.3),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        imagePath,
                        width: 36, // ปรับขนาดไอคอน
                        height: 36,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            color: isSelected
                                ? Color(0xFF8B4513)
                                : Color(0xFF8B4513).withOpacity(0.5),
                            size: 28,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: Color(0xFF000000),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getAvatarBorderColor() {
    if (playerLevel >= 50) {
      return Color(0xFFCEFFB2);
    } else {
      return Color(0xFF75C6EA);
    }
  }
}
