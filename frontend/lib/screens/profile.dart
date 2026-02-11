import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
              'assets/images/bgProfile.png',
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
                  // 1. Profile Information Box
                  _buildProfileBox(),
                  
                  const SizedBox(height: 40),
                  
                  // 2. Statistics Box
                  _buildStatBox(),
                  
                  const SizedBox(height: 20),

                  // 3. Achievements Box
                  _buildAchievementBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Section 1: Top Bar
  // ===========================================================================

  /// Builds the top navigation bar overlay.
  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Semi-transparent black overlay
          Container(
            height: 75,
            color: Colors.black.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Section 2: Profile Box
  // ===========================================================================

  /// Builds the main profile card containing avatar, name, bio, and experience.
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
          // Decorative Background Images
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/designProfile.png',
              height: 180, 
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 3,
            right: 3,
            child: Image.asset(
              'assets/images/design1.png',
              width: 50,
              fit: BoxFit.contain,
            ),
          ),

          // Main Content Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar Area
                _buildAvatarSection(),
                
                const SizedBox(width: 16),
                
                // User Info Area
                _buildUserInfoSection(),
              ],
            ),
          ),
        ], 
      ),
    );
  }

  /// Builds the avatar section including the circular EXP bar and level indicator.
  Widget _buildAvatarSection() {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Circular EXP Bar & Avatar Image
          Stack(
            alignment: Alignment.center,
            children: [
              // Circular EXP Tube
              CustomPaint(
                size: const Size(130, 130),
                painter: GradientCircularProgressPainter(
                  progress: 0.42,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF88FF40), Color(0xFF66E0FF)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  strokeWidth: 8,
                ),
              ),
              
              // Avatar Image
              Container(
                padding: const EdgeInsets.all(8),
                child: const CircleAvatar(
                  radius: 54,
                  backgroundImage: AssetImage('assets/images/profile_img.png'),
                ),
              ),
            ],
          ),

          // Level Badge
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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "3",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.black,
                      height: 1,
                    ),
                  ),
                  Text(
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

  /// Builds the user information column (UID, Name, Bio, EXP Bar).
  Widget _buildUserInfoSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // UID
          Row(
            children: [
              const Text(
                "UID : 8905066",
                style: TextStyle(
                  color: Color(0xFF00385D), 
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 5),
              Image.asset(
                'assets/images/iconCopy.png',
                width: 16,
                height: 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Name Field
          _buildInfoField(
            content: "UsakiB",
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
            borderColor: const Color(0xFF9DD0E7),
            iconColor: const Color(0xFF1E5173),
            height: 35,
          ),
          const SizedBox(height: 6),
          
          // Bio Field
          _buildInfoField(
            content: "แนะนำตัว",
            textStyle: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            borderColor: const Color(0xFF9DD0E7),
            iconColor: const Color(0xFF1E5173),
            height: 30,
            iconSize: 14,
          ),
          const SizedBox(height: 8),
          
          // Linear EXP Bar
          _buildLinearExpBar(),
        ],
      ),
    );
  }

  /// Helper to build standardized info fields (Name, Bio).
  Widget _buildInfoField({
    required String content,
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
          Text(content, style: textStyle),
          Image.asset(
              'assets/images/iconEdit.png',
              width: iconSize,
              height: iconSize,
              color: iconColor,
          ),
        ],
      ),
    );
  }

  /// Builds the linear experience progress bar.
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
            const Text(
              "42/100",
              style: TextStyle(
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
                // Background Track
                Container(
                  height: 12,
                  color: const Color(0xFF535353),
                ),
                // Progress Fill
                FractionallySizedBox(
                  widthFactor: 0.42,
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

  // ===========================================================================
  // Section 3: Statistics Box
  // ===========================================================================

  /// Builds the Stat Box with user stats.
  Widget _buildStatBox() {
    return Column(
      children: [
        // Header
        _buildBoxHeader(
          iconPath: 'assets/images/statlogo-img.png',
          title: "ค่าความสามารถ",
        ),
        
        // Body
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: _buildBoxDecoration(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Character Image
              Image.asset(
                'assets/images/profile-character.png',
                height: 160,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              
              // Stats List
              Expanded(
                child: Column(
                  children: [
                    _buildStatRow('assets/images/stat-int-img.png', "ความฉลาด", "12"),
                    const SizedBox(height: 8),
                    _buildStatRow('assets/images/stat-str-img.png', "ความแข็งแรง", "9"),
                    const SizedBox(height: 8),
                    _buildStatRow('assets/images/stat-cre-img.png', "ความคิดสร้างสรรค์", "10"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a single row for a statistic (icon, label, value).
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

  // ===========================================================================
  // Section 4: Achievements Box
  // ===========================================================================

  /// Builds the Achievements Box.
  Widget _buildAchievementBox() {
    return Column(
      children: [
        // Header
        _buildBoxHeader(
          iconPath: 'assets/images/IconAcheivement.png',
          title: "ความสำเร็จ 3/18",
        ),
        
        // Body
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: _buildBoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildAchievementItem('assets/images/achievement1.png'),
              const SizedBox(width: 10),
              _buildAchievementItem('assets/images/achievement2.png'),
              const SizedBox(width: 10),
              _buildAchievementItem('assets/images/achievement3.png'),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a single circular achievement item.
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

  // ===========================================================================
  // Section 5: Common Helpers
  // ===========================================================================

  /// Common header for Stat and Achievement boxes.
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
              'assets/images/design1.png',
              width: 50,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  /// Common decoration for box bodies (white semi-transparent with blue border).
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

// ===========================================================================
// Section 6: Custom Painters
// ===========================================================================

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
    
    // Draw background track
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

    // Start from Bottom-Right (pi/4) and go Clockwise (2*pi*progress)
    // The level circle is at bottom-right corner (~45 degrees).
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