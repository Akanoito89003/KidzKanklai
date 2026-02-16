import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_service.dart';


import 'package:flutter_application_1/widgets/bottom_navigation_bar.dart';
import 'package:flutter_application_1/widgets/custom_top_bar.dart';
import 'package:flutter_application_1/widgets/reward_popup.dart';
import 'package:flutter_application_1/screens/lobby.dart';

class AchievementScreen extends StatefulWidget {
  final User? user;
  final VoidCallback? onClose;
  const AchievementScreen({super.key, this.user, this.onClose});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  int _selectedIndex = 1;
  int? _expandedAchievementIndex;
  bool _isPressed = false;

  // Mock achievement data
  final List<Achievement> achievements = [
    Achievement(
      id: '1',
      name: 'นักวางแผนมือใหม่',
      description:
          'ราชวิวความสำเร็จจบของการที่มีความมานับหมดที่ต้องทำหว้ามองเอียนแอปริเคชัน',
      imagePath: 'assets/images/achievement/achievement_1.png',
      isUnlocked: true,
      hasNotification: false,
      reward: AchievementReward(type: 'EXP', amount: 100),
      isClaimed: false,
    ),
    Achievement(
      id: '2',
      name: 'ผู้ท้าทายตัวเอง',
      description: 'ทำภารกิจยากสำเร็จ',
      imagePath: 'assets/images/achievement/achievement_2.png',
      isUnlocked: true,
      hasNotification: true,
      reward: AchievementReward(type: 'EXP', amount: 100),
      isClaimed: false,
    ),
    Achievement(
      id: '3',
      name: 'ล็อคอยู่',
      description: 'ยังไม่ปลดล็อค',
      imagePath: null,
      isUnlocked: false,
      hasNotification: false,
      reward: null,
      isClaimed: false,
    ),
    Achievement(
      id: '4',
      name: 'ผู้เชี่ยวชาญ',
      description: 'ทำภารกิจทั้งหมดสำเร็จ',
      imagePath: 'assets/images/achievement/achievement_4.png',
      isUnlocked: false,
      hasNotification: false,
      reward: AchievementReward(type: 'EXP', amount: 500),
      isClaimed: false,
    ),
    Achievement(
      id: '5',
      name: 'นักสะสม',
      description: 'สะสมไอเท็มครบทุกชิ้น',
      imagePath: null,
      isUnlocked: false,
      hasNotification: false,
      reward: AchievementReward(type: 'EXP', amount: 300),
      isClaimed: false,
    ),
    Achievement(
      id: '6',
      name: 'ผู้พิชิตเวลา',
      description: 'ทำภารกิจให้เสร็จภายในเวลาที่กำหนด',
      imagePath: 'assets/images/achievement/achievement_6.png',
      isUnlocked: true,
      hasNotification: false,
      reward: AchievementReward(type: 'EXP', amount: 200),
      isClaimed: true,
    ),
    Achievement(
      id: '7',
      name: 'นักสำรวจ',
      description: 'ค้นพบสถานที่ลับทั้งหมด',
      imagePath: null,
      isUnlocked: false,
      hasNotification: false,
      reward: AchievementReward(type: 'EXP', amount: 400),
      isClaimed: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/background/bg1.png', fit: BoxFit.cover),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 200),
                    padding: EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 30),

                        Text(
                          'จำนวน 2/18',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 20),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(children: _buildAchievementList()),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildHeaderTitle(),
                ],
              ),
            ),
          ),

          //Back Button and Top Bar
          _buildTopBar(),
          // Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavigationBar(
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
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAchievementList() {
    List<Widget> widgets = [];

    for (int i = 0; i < achievements.length; i += 3) {
      // Achievement Row (3 items)
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int j = i; j < i + 3 && j < achievements.length; j++)
              Expanded(child: _buildAchievementItem(achievements[j], j)),
            // Fill remaining slots with empty space
            for (int k = achievements.length - i; k < 3 && i + k < i + 3; k++)
              Expanded(child: SizedBox()),
          ],
        ),
      );

      // Dropdown Detail (if expanded)
      if (_expandedAchievementIndex != null &&
          _expandedAchievementIndex! >= i &&
          _expandedAchievementIndex! < i + 3) {
        widgets.add(
          _buildAchievementDetail(achievements[_expandedAchievementIndex!]),
        );
      }

      widgets.add(SizedBox(height: 16));
    }

    return widgets;
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

          // Back Button
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) {},
              onTapCancel: () => setState(() => _isPressed = false),
              onTap: () async {
                await Future.delayed(const Duration(milliseconds: 200));
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LobbyScreen()),
                ).then((_) {
                  setState(() => _isPressed = false);
                });
              },
              child: Image.asset(
                _isPressed
                    ? 'assets/images/button/bt-hover-Back.png'
                    : 'assets/images/button/bt-Back.png',
                width: 50,
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(Achievement achievement, int index) {
    final isExpanded = _expandedAchievementIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _expandedAchievementIndex = isExpanded ? null : index;
        });
      },
      child: Container(
        margin: EdgeInsets.all(4),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Achievement Circle
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: achievement.isUnlocked
                    ? Colors.white
                    : Color(0xFFB3E5FC).withValues(alpha: 0.5),
                border: Border.all(
                  color: isExpanded
                      ? Color(0xFF64B5F6)
                      : Colors.white.withOpacity(0.8),
                  width: isExpanded ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: achievement.isUnlocked && achievement.imagePath != null
                    ? ClipOval(
                        child: Image.asset(
                          achievement.imagePath!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildLockedIcon();
                          },
                        ),
                      )
                    : _buildLockedIcon(),
              ),
            ),

            // Red Notification Dot
            if (achievement.hasNotification && achievement.isUnlocked)
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE53935),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedIcon() {
    return Text(
      '?',
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildAchievementDetail(Achievement achievement) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 8),
      width: 400,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFB3E5FC).withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Title
          Text(
            achievement.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8),

          // Description
          Text(
            achievement.description,
            style: TextStyle(fontSize: 13, color: Colors.black87),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 12),

          // Reward Section
          if (achievement.reward != null && !achievement.isClaimed)
            Column(
              children: [
                // Reward Icon - EXP image on top, amount below
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // EXP Image
                      Image.asset(
                        "assets/images/item/EXP.png",
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.stars,
                            size: 40,
                            color: Color(0xFFFFA726),
                          );
                        },
                      ),
                      SizedBox(height: 4),
                      // Amount below image
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '+${achievement.reward!.amount}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.check_circle,
                            color: Color(0xFF66BB6A),
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12),

                // Claim Button with Gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF66BB6A).withOpacity(0.4),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        achievement.isClaimed = true;
                        achievement.hasNotification = false;
                      });
                      RewardPopup.show(
                        context,
                        rewardType: 'EXP',
                        amount: achievement.reward!.amount,
                        onClose: () {
                          Navigator.of(context).pop();
                        },
                      );
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('รับรางวัลแล้ว!')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'รับรางวัล',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          // Already Claimed
          if (achievement.isClaimed)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'รับรางวัลแล้ว',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return Positioned(
      top: 160,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: FractionalTranslation(
          translation: const Offset(0, -0.5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF005395), Color(0xFF2374B5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              // white border inside box
              borderRadius: BorderRadius.circular(6),
              border: Border.fromBorderSide(
                BorderSide(color: Colors.white, width: 2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔹 รูปด้านหน้า
                Image.asset(
                  'assets/assets/icon/iconAchievement_icon.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),

                const SizedBox(width: 12),

                // 🔹 ข้อความ
                const Text(
                  "ความสำเร็จ",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Achievement Model
class Achievement {
  final String id;
  final String name;
  final String description;
  final String? imagePath;
  final bool isUnlocked;
  bool hasNotification;
  final AchievementReward? reward;
  bool isClaimed;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    this.imagePath,
    required this.isUnlocked,
    required this.hasNotification,
    this.reward,
    this.isClaimed = false,
  });
}

class AchievementReward {
  final String type; // EXP, COINS, etc.
  final int amount;

  AchievementReward({required this.type, required this.amount});
}
