import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kidz_kanklai/frontend/login.dart';

class StartGamePage extends StatefulWidget {
  const StartGamePage({super.key});

  @override
  State<StartGamePage> createState() => _StartGamePageState();
}

class _StartGamePageState extends State<StartGamePage> with SingleTickerProviderStateMixin {
  int _phase = 0;

  // Opacity States
  double _logoOpacity = 0.0;
  double _loadingScreenOpacity = 0.0;
  double _enterButtonOpacity = 0.0;
  
  // Animation Controller for Progress Bar
  late AnimationController _progressController;

  // ==========================================
  // Lifecycle Methods
  // ==========================================

  @override
  void initState() {
    super.initState();
    
    // Initialize Progress Bar Controller (3 seconds duration)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Listen for progress completion to trigger Phase 3
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _transitionToPhase3();
      }
    });
    
    // Start the main animation sequence after the first frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _runAnimationSequence();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  // ==========================================
  // Animation Logic
  // ==========================================

  Future<void> _runAnimationSequence() async {
    // 1. Initial Delay
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    
    // 2. Phase 0: Fade In Logo
    setState(() {
      _phase = 0;
      _logoOpacity = 1.0;
    });
    
    // Hold Logo for 5 seconds
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;

    // 3. Phase 1: Fade Out Logo
    setState(() {
      _phase = 1;
      _logoOpacity = 0.0;
    });
    
    // Wait for Fade Out (2 seconds)
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // 4. Phase 2: Fade In Loading Screen
    setState(() {
      _phase = 2;
      _loadingScreenOpacity = 1.0;
    });

    // Short delay before starting progress bar
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    // Start Progress Bar Animation
    _progressController.forward();
  }

  void _transitionToPhase3() {
    if (!mounted) return;
    
    setState(() {
      _phase = 3;
    });

    // Slight delay before fading in the button
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _enterButtonOpacity = 1.0;
        });
      }
    });
  }

  // ==========================================
  // Navigation
  // ==========================================

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const LoginPage())
    );
  }

  // ==========================================
  // UI Building
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // --------------------------
          // Phase 0 & 1: Logo Intro
          // --------------------------
          if (_phase < 2)
            _buildIntroPhase(),
            
          // --------------------------
          // Phase 2 & 3: Game Screen
          // --------------------------
          if (_phase >= 2)
            _buildGamePhase(),
        ],
      ),
    );
  }

  /// Builds the Initial Logo Animation (Phase 0 & 1)
  Widget _buildIntroPhase() {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        opacity: _logoOpacity,
        child: _buildLogoImage(width: 300),
      ),
    );
  }

  /// Builds the Main Game Screen (Phase 2 & 3)
  Widget _buildGamePhase() {
    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      opacity: _loadingScreenOpacity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset(
            'assets/images/bgStartgame.png',
            fit: BoxFit.cover,
          ),
          
          // 2. Top Black Gradient Overlay (Only in Phase 3)
          if (_phase == 3)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          
          // 3. Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              
              // Top Logo
              _buildLogoImage(width: 250),
              
              const Spacer(),
              
              // Bottom Section: Loading Bar OR Enter Button
              if (_phase == 2)
                _buildLoadingBar(),
                
              if (_phase == 3)
                _buildEnterSystemButton(),
                
              const SizedBox(height: 100),
            ],
          ),
        ],
      ),
    );
  }

  /// Reusable Logo Image Widget
  Widget _buildLogoImage({required double width}) {
    return Image.asset(
      'assets/images/logo.png',
      width: width,
      fit: BoxFit.contain,
    );
  }

  /// Phase 2: Loading Progress Bar & Text
  Widget _buildLoadingBar() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        final percentage = (_progressController.value * 100).toInt();
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              // Progress Bar Container
              Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // Gradient Fill
                        Container(
                          width: constraints.maxWidth * _progressController.value,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF59ABEC), Color(0xFF85D755)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              
              // Loading Text & Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/icon-loading.png',
                    width: 45,
                    height: 45,
                  ),
                  const SizedBox(width: 8),
                  _buildOutlinedText("Loading...($percentage%)"),
                ],
              )
            ],
          ),
        );
      }
    );
  }

  /// Phase 3: "Enter System" Button
  Widget _buildEnterSystemButton() {
    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      opacity: _enterButtonOpacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60), // Side padding for centered look
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _navigateToLogin,
            child: Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                    Colors.transparent
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: const Text(
                "เข้าสู่ระบบ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.black45, offset: Offset(0, 1), blurRadius: 4)
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper to build text with black outline and white fill
  Widget _buildOutlinedText(String text) {
    return Stack(
      children: [
        // Outline (Black)
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = Colors.black,
          ),
        ),
        // Fill (White)
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
