import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = Supabase.instance.client;

  // --- Profile Data ---
  String _displayName = "Loading...";
  String _displayBio = "กำลังโหลดข้อมูล...";
  String _uid = "Loading...";

  // --- Character Stats & Level Data ---
  int _level = 1;
  int _currentExp = 0; // EXP ที่เหลืออยู่ในเลเวลปัจจุบัน
  int _nextLevelExp = 40; // EXP ที่ต้องใช้เพื่อขึ้นเลเวลถัดไป
  double _expPercent = 0.0; // ค่า 0.0 - 1.0 สำหรับหลอดเลือด

  String _intStat = "10";
  String _strStat = "10";
  String _creStat = "10";

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // ฟังก์ชันคำนวณ Level และ EXP ตาม Logic ที่กำหนด
  void _calculateLevelInfo(int totalExp) {
    int level = 1;
    int remainingExp = totalExp;
    int requiredExp = 0;

    while (true) {
      // สูตรคำนวณ EXP ที่ต้องการในแต่ละเลเวล
      if (level < 6) {
        // level 1-5 : 40 * L
        requiredExp = 40 * level;
      } else {
        // level 6+ : 200 + L^2
        requiredExp = 200 + (level * level);
      }

      if (remainingExp >= requiredExp) {
        remainingExp -= requiredExp;
        level++;
      } else {
        // EXP ไม่พออัปเลเวล จบการคำนวณที่เลเวลนี้
        break;
      }
    }

    if (mounted) {
      setState(() {
        _level = level;
        _currentExp = remainingExp;
        _nextLevelExp = requiredExp;
        // คำนวณ % (กันหารด้วย 0)
        _expPercent = (_nextLevelExp > 0) 
            ? (_currentExp / _nextLevelExp).clamp(0.0, 1.0) 
            : 0.0;
      });
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      setState(() {
        _uid = user.id.substring(0, 8); // ตัด UID มาแสดงสั้นๆ
      });

      // 1. ดึงข้อมูล Profile (ชื่อ, Bio)
      final profileData = await _supabase
          .from('user_profiles')
          .select('user_name, user_detail')
          .eq('user_id', user.id)
          .maybeSingle();

      if (profileData != null) {
        setState(() {
          _displayName = profileData['user_name'] ?? "No Name";
          _displayBio = profileData['user_detail'] ?? "ยังไม่มีคำแนะนำตัว";
        });
      }

      // 2. ดึงข้อมูล Character (Stats, EXP)
      final charData = await _supabase
          .from('characters')
          .select('character_experience, character_intelligence, character_strength, character_creative')
          .eq('user_id', user.id)
          .maybeSingle();

      if (charData != null) {
        // อัปเดต Stat
        setState(() {
          _intStat = charData['character_intelligence'].toString();
          _strStat = charData['character_strength'].toString();
          _creStat = charData['character_creative'].toString();
        });

        // คำนวณ Level จาก Total EXP
        final totalExp = charData['character_experience'] as int? ?? 0;
        _calculateLevelInfo(totalExp);
      }

    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  void _showEditDialog(String title, String currentValue, String columnToUpdate) {
    final TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("แก้ไข$title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "กรอก$titleใหม่"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ยกเลิก"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newValue = controller.text.trim();
                if (newValue.isNotEmpty) {
                  try {
                    final userId = _supabase.auth.currentUser!.id;
                    await _supabase.from('user_profiles').update({
                      columnToUpdate: newValue
                    }).eq('user_id', userId);

                    if (mounted) {
                      setState(() {
                        if (columnToUpdate == 'user_name') _displayName = newValue;
                        if (columnToUpdate == 'user_detail') _displayBio = newValue;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('บันทึกข้อมูลเรียบร้อย')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                    );
                  }
                }
              },
              child: const Text("บันทึก"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background/bg4.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Top Bar Overlay
          _buildTopBar(),

          // Main Scrollable Content
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 12, right: 12, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileBox(),
                  const SizedBox(height: 40),
                  _buildStatBox(),
                  const SizedBox(height: 20),
                  _buildAchievementBox(),
                ],
              ),
            ),
          ),
        ],
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
            color: Colors.black.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileBox() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10), 
        border: Border.all(color: const Color(0xFF9DD0E7), width: 2),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/design/design2.png',
              height: 180, 
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 3,
            right: 3,
            child: Image.asset(
              'assets/images/design/design1.png',
              width: 50,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAvatarSection(),
                const SizedBox(width: 16),
                _buildUserInfoSection(),
              ],
            ),
          ),
        ], 
      ),
    );
  }

  Widget _buildAvatarSection() {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(130, 130),
                painter: GradientCircularProgressPainter(
                  progress: _expPercent, // [UPDATED] ใช้ค่าจริง
                  gradient: const LinearGradient(
                    colors: [Color(0xFF88FF40), Color(0xFF66E0FF)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  strokeWidth: 8,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: const CircleAvatar(
                  radius: 54,
                  backgroundImage: AssetImage('assets/images/profile/profile_img.png'),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Colors.white, Color(0xFFE0E0E0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$_level", // [UPDATED] แสดง Level จริง
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.black,
                      height: 1,
                    ),
                  ),
                  const Text(
                    "Lv.",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      height: 1,
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

  Widget _buildUserInfoSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                "UID : $_uid", // [UPDATED] แสดง UID จริง
                style: const TextStyle(
                  color: Color(0xFF00385D), 
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 5),
              Image.asset(
                'assets/images/icon/iconCopy.png',
                width: 16,
                height: 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoField(
            content: _displayName,
            columnName: 'user_name',
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
            borderColor: const Color(0xFF9DD0E7),
            iconColor: const Color(0xFF1E5173),
            height: 35,
          ),
          const SizedBox(height: 6),
          _buildInfoField(
            content: _displayBio,
            columnName: 'user_detail',
            textStyle: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              overflow: TextOverflow.ellipsis,
            ),
            borderColor: const Color(0xFF9DD0E7),
            iconColor: const Color(0xFF1E5173),
            height: 30,
            iconSize: 14,
          ),
          const SizedBox(height: 8),
          _buildLinearExpBar(),
        ],
      ),
    );
  }

  Widget _buildInfoField({
    required String content,
    required String columnName,
    required TextStyle textStyle,
    required Color borderColor,
    required Color iconColor,
    double height = 35,
    double iconSize = 16,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(content, style: textStyle)),
          GestureDetector(
            onTap: () {
              _showEditDialog(
                columnName == 'user_name' ? 'ชื่อ' : 'แนะนำตัว',
                content,
                columnName
              );
            },
            child: Image.asset(
              'assets/images/icon/iconEdit.png',
              width: iconSize,
              height: iconSize,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinearExpBar() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "EXP",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "$_currentExp/$_nextLevelExp", // [UPDATED] แสดง EXP จริง
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Container(
          height: 16,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(
                  height: 12,
                  color: const Color(0xFF535353),
                ),
                FractionallySizedBox(
                  widthFactor: _expPercent, // [UPDATED] ใช้ % จริง
                  child: Container(
                    height: 12,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF88FF40), Color(0xFF66E0FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox() {
    return Column(
      children: [
        _buildBoxHeader(
          iconPath: 'assets/images/icon/icon-white-loading.png',
          title: "ค่าความสามารถ",
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: _buildBoxDecoration(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/profile/profile-character.png',
                height: 160,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    // [UPDATED] ใช้ตัวแปร Stat ที่ดึงมาจาก DB
                    _buildStatRow('assets/images/profile/stat-int-img.png', "ความฉลาด", _intStat),
                    const SizedBox(height: 8),
                    _buildStatRow('assets/images/profile/stat-str-img.png', "ความแข็งแรง", _strStat),
                    const SizedBox(height: 8),
                    _buildStatRow('assets/images/profile/stat-cre-img.png', "ความคิดสร้างสรรค์", _creStat),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String iconPath, String label, String value) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF2E4C6D),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(iconPath, fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Text(
             value,
             style: const TextStyle(
               fontWeight: FontWeight.bold,
               fontSize: 14,
               color: Colors.black,
             ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildAchievementBox() {
    return Column(
      children: [
        _buildBoxHeader(
          iconPath: 'assets/images/icon/iconAcheivement.png',
          title: "ความสำเร็จ 3/18",
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: _buildBoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildAchievementItem('assets/images/achievement/achievement1.png'),
              const SizedBox(width: 10),
              _buildAchievementItem('assets/images/achievement/achievement2.png'),
              const SizedBox(width: 10),
              _buildAchievementItem('assets/images/achievement/achievement3.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementItem(String imagePath) {
    return Container(
      width: 55,
      height: 55,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF9DD0E7), width: 2),
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBoxHeader({required String iconPath, required String title}) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2374B5), Color(0xFF9DD0E7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 14, right: 6),
        child: Row(
          children: [
              Image.asset(
              iconPath,
              height: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Image.asset(
              'assets/images/design/design1.png',
              width: 50,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.5),
      border: const Border(
        left: BorderSide(color: Color(0xFF9DD0E7), width: 2),
        right: BorderSide(color: Color(0xFF9DD0E7), width: 2),
        bottom: BorderSide(color: Color(0xFF9DD0E7), width: 2),
      ),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final Gradient gradient;
  final double strokeWidth;

  GradientCircularProgressPainter({
    required this.progress,
    required this.gradient,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = Colors.grey.withValues(alpha: 0.2);
      
    canvas.drawCircle(center, radius, trackPaint);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159 / 4, 
      2 * 3.14159 * progress, 
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}