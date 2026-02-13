import 'package:flutter/material.dart';
<<<<<<< HEAD

import 'package:flutter_application_1/screens/test.dart';

class SettingLogoutScreen extends StatefulWidget {
  const SettingLogoutScreen({super.key});

  @override
  State<SettingLogoutScreen> createState() => _SettingLogoutScreenState();
}

class _SettingLogoutScreenState extends State<SettingLogoutScreen> {
=======
import 'test.dart';

class SettingLogoutPage extends StatefulWidget {
  const SettingLogoutPage({super.key});

  @override
  State<SettingLogoutPage> createState() => _SettingLogoutPageState();
}

class _SettingLogoutPageState extends State<SettingLogoutPage> {
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
  // State Variables
  bool _isPressed = false;
  bool _isMuted = false;
  double _musicVolume = 0.7;
  double _sfxVolume = 0.7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bgSetting.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Top Bar Overlay
          _buildTopBar(),

          // Main Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 150, 24, 24),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // White Content Container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.82),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFAAD7EA),
                      width: 3,
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                           const SizedBox(height: 50),
                           _buildUserAccountSection(),
                           _buildVolumeSettingsSection(),
                        ],
                      ),
                    ), 
                  ),
                ),
                
                // Header Title
                _buildHeaderTitle(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the top bar with the black overlay and back button.
  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Black Overlay Box
          Container(
            height: 75,
            color: Colors.black.withOpacity(0.4),
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
<<<<<<< HEAD
                  MaterialPageRoute(builder: (context) => const TestScreen()),
=======
                  MaterialPageRoute(builder: (context) => const TestPage()),
>>>>>>> a1cf77918108193f7f002afabfdd5ba258c99701
                ).then((_) {
                  setState(() => _isPressed = false);
                });
              },
              child: Image.asset(
                _isPressed
                    ? 'assets/images/bt-hover-Back.png'
                    : 'assets/images/bt-Back.png',
                width: 50,
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the User Account section with guest UI.
  Widget _buildUserAccountSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          // Section Header
          Row(
            children: [
              Image.asset(
                'assets/images/IconPerson.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              const Text(
                "บัญชีผู้ใช้",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Divider
          Container(
            height: 3,
            width: double.infinity,
            color: const Color(0xFFCCE7F2),
          ),
          const SizedBox(height: 20),
          
          // Guest Character Image
          Center(
            child: Image.asset(
              'assets/images/setting-character.png',
              width: 140,
            ),
          ),
          const SizedBox(height: 10),
          
          // "Not Logged In" Text
          const Center(
            child: Text(
              "ยังไม่ได้เข้าสู่ระบบ",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 15),
          
          // Login Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to Login Page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF556AEB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the Volume Settings section.
  Widget _buildVolumeSettingsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: [
          // Section Header
          Row(
            children: [
              Image.asset(
                'assets/images/IconVolume.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              const Text(
                "ระดับเสียง",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Divider
          Container(
            height: 3,
            width: double.infinity,
            color: const Color(0xFFCCE7F2),
          ),
          const SizedBox(height: 5),
          const SizedBox(height: 5),
          
          // Mute all Toggle
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFBADEEE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "ปิดเสียงทั้งหมด",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMuted = !_isMuted;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 70,
                    height: 32,
                    padding: const EdgeInsets.all(2), 
                    decoration: BoxDecoration(
                      color: _isMuted 
                          ? Colors.white.withOpacity(0.8) 
                          : const Color(0xFF002A50), 
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF002A50),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (_isMuted)
                          const Positioned(
                            left: 8,
                            top: 2,
                            bottom: 2,
                            child: Center(
                              child: Text(
                                "ON",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                        if (!_isMuted)
                          const Positioned(
                            right: 8,
                            top: 2,
                            bottom: 2,
                            child: Center(
                              child: Text(
                                "OFF",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: _isMuted ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            width: 24, 
                            height: 24,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF2374B5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Sliders
          _buildVolumeSlider(
            label: "Music / BGM",
            value: _musicVolume,
            onChanged: (val) => setState(() => _musicVolume = val),
          ),
          const SizedBox(height: 6),
          _buildVolumeSlider(
            label: "Sound Effects / SFX",
            value: _sfxVolume,
            onChanged: (val) => setState(() => _sfxVolume = val),
          ),
        ],
      ),
    );
  }

  /// Helper method to build a volume slider row.
  Widget _buildVolumeSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 6, 15, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFBADEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label [ ${(value * 100).toInt()}% ]",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  final newValue = (value - 0.1).clamp(0.0, 1.0);
                  onChanged(newValue);
                },
                child: const Icon(Icons.arrow_left, size: 50, color: Color(0xFF2374B5)),
              ),
              Expanded(
                child: SizedBox(
                   height: 30, 
                   child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                       trackHeight: 10,
                      trackShape: const GradientRectSliderTrackShape(
                        gradient: LinearGradient(
                          colors: [Color(0xFF59ABEC), Color(0xFF85D755)],
                        ),
                        darkenInactive: false,
                      ),
                      thumbShape: const CircleThumbShape(
                        thumbRadius: 10,
                        thumbColor: Color(0xFF2374B5),
                        borderColor: Color(0xFF002A50),
                        borderWidth: 2,
                      ),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
                      overlayColor: const Color(0xFF2374B5).withOpacity(0.2),
                      activeTrackColor: Colors.transparent, 
                      inactiveTrackColor: Colors.white, 
                    ),
                    child: Slider(
                      value: value,
                      onChanged: onChanged,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  final newValue = (value + 0.1).clamp(0.0, 1.0);
                  onChanged(newValue);
                },
                child: const Icon(Icons.arrow_right, size: 50, color: Color(0xFF2374B5)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the floating header title ("ตั้งค่า").
  Widget _buildHeaderTitle() {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionalTranslation(
        translation: const Offset(0, -0.5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2374B5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text(
            "ตั้งค่า",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Slider Shapes

class CircleThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final Color thumbColor;
  final Color borderColor;
  final double borderWidth;

  const CircleThumbShape({
    this.thumbRadius = 12.0,
    required this.thumbColor,
    required this.borderColor,
    this.borderWidth = 2.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint fillPaint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, thumbRadius, fillPaint);
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}

class GradientRectSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  final LinearGradient gradient;
  final bool darkenInactive;

  const GradientRectSliderTrackShape({
    this.gradient = const LinearGradient(colors: [Colors.lightBlue, Colors.blue]),
    this.darkenInactive = true,
  });

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    final Canvas canvas = context.canvas;
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    
    final Paint activePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..style = PaintingStyle.fill;

    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? Colors.white
      ..style = PaintingStyle.fill;

    final Radius radius = Radius.circular(trackRect.height / 2);

    final RRect fullRRect = RRect.fromRectAndRadius(trackRect, radius);

    context.canvas.save();
    context.canvas.clipRect(Rect.fromLTRB(thumbCenter.dx, trackRect.top, trackRect.right, trackRect.bottom));
    context.canvas.drawRRect(fullRRect, inactivePaint);
    context.canvas.restore();

    context.canvas.save();
    context.canvas.clipRect(Rect.fromLTRB(trackRect.left, trackRect.top, thumbCenter.dx, trackRect.bottom));
    context.canvas.drawRRect(fullRRect, activePaint);
    context.canvas.restore();
  }
}