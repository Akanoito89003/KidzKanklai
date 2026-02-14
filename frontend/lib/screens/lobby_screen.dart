import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import '../api_service.dart';
import 'login_screen.dart';
import 'fashion_screen.dart';
import 'quest_screen.dart';
import 'settings_screen.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/rive_cache.dart';

class LobbyScreen extends StatefulWidget {
  final User user;
  const LobbyScreen({super.key, required this.user});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late User _currentUser;

  bool _isLoading = false;
  StateMachineController? _controller;
  SMINumber? _poseInput;
  SMINumber? _hairInput; 
  SMITrigger? _tapInput; // Trigger for tap interaction

  void _onRiveInit(Artboard artboard) {
    var controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller == null && artboard.stateMachines.isNotEmpty) {
       // Fallback: use the first state machine found
       controller = StateMachineController.fromArtboard(artboard, artboard.stateMachines.first.name);
       print("LobbyScreen: Default 'State Machine 1' not found. Using '${artboard.stateMachines.first.name}'");
    }

    if (controller != null) {
      artboard.addController(controller);
      _controller = controller;
      
      // Debug: Print all inputs
      print("LobbyScreen: Available Inputs -> ${controller.inputs.map((e) => e.name).toList()}");

      _poseInput = controller.findInput<SMINumber>('Pose') as SMINumber?;
      
      // Fuzzy search for HairID
      try {
        var hairInputRaw = controller.inputs.firstWhere((e) => e.name.toLowerCase() == 'hairid' || e.name == 'Hair_ID', orElse: () => controller!.inputs.firstWhere((e) => e.name.contains('Hair'), orElse: () => controller!.inputs.first));
        if (hairInputRaw is SMINumber) {
           _hairInput = hairInputRaw;
           print("LobbyScreen: Found Hair Input as '${hairInputRaw.name}'");
        }
      } catch (e) {
         print("LobbyScreen: Could not fuzzy find HairID input");
      }

      // Fuzzy search for Tapcharacter
      try {
        var tapInputRaw = controller!.inputs.firstWhere((e) => e.name.toLowerCase() == 'tapcharacter' || e.name.toLowerCase() == 'tap', orElse: () => controller!.inputs.firstWhere((e) => e is SMITrigger, orElse: () => controller!.inputs.first));
        if (tapInputRaw is SMITrigger) {
           _tapInput = tapInputRaw;
           print("LobbyScreen: Found Tap Input as '${tapInputRaw.name}'");
        }
      } catch (e) {
         print("LobbyScreen: Could not fuzzy find Tap input");
      }
      
      print("LobbyScreen: Rive Controller Init. Inputs found -> Pose: ${_poseInput?.name}, Hair: ${_hairInput?.name}, Tap: ${_tapInput?.name}");
      
       // Sync Hair with User Profile
       if (_hairInput != null && _currentUser.equippedHair.isNotEmpty) {
          print("LobbyScreen: Syncing Hair. Profile has: '${_currentUser.equippedHair}'");
          // Format expected: "Hair Style X" -> ID = X
          // "Hair Style 0" -> 0
          try {
            if (_currentUser.equippedHair.startsWith("Hair Style ")) {
               String numberPart = _currentUser.equippedHair.replaceAll("Hair Style ", "");
               int id = int.parse(numberPart);
               
               // Force update trick: if id is 0, set to -1 first (if input allows) or just ensure it's set
               // Actually, let's print the current value first
               print("LobbyScreen: Current Rive HairID value: ${_hairInput!.value}");
               
               if (id == 0 && _hairInput!.value == 0) {
                  // If already 0, Rive might be stuck in default state (Pink?). 
                  // Let's try to 'jiggle' it? Or maybe the default IS 0 (Pink).
                  // If Hair 0 is Blue, but Rive shows Pink at 0, then Rive file is wrong.
                  // But user says "Select Hair 0 -> Pink". 
                  // Let's force set it.
                  _hairInput!.value = 0.0;
               } else {
                  _hairInput!.value = id.toDouble();
               }

               print("LobbyScreen: Success! Set HairID to ${_hairInput!.value}");
            } else if (_currentUser.equippedHair == "default_blue") {
               _hairInput!.value = 0; // Default
               print("LobbyScreen: Set HairID to 0 (default_blue)");
            } else {
               print("LobbyScreen: Unrecognized hair format '${_currentUser.equippedHair}', defaulting to 0");
               _hairInput!.value = 0;
            }
          } catch (e) {
            print("LobbyScreen: Error parsing hair ID: $e");
          }
       } else {
          print("LobbyScreen: Cannot sync hair. _hairInput is null or equippedHair empty.");
       }
    }
    // Mark initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _isRiveLoaded = true);
    });
  }
  bool _isRiveLoaded = false; 

  @override
  void initState() {
    super.initState();
    print("LobbyScreen: initState called");
    _currentUser = widget.user;
    
    // Removed debug loading (was causing double load)
    // Removed arbitrary delay (was making it feel slow)

    _refreshProfile();
  }

  // Debug function removed to save resources


  Future<void> _refreshProfile() async {
    print("LobbyScreen: Refreshing profile...");
    setState(() => _isLoading = true);
    try {
      final updatedUser = await ApiService.getProfile(_currentUser.id).timeout(const Duration(seconds: 5));
      if (updatedUser != null) {
        print("LobbyScreen: Profile updated for ${updatedUser.username}");
        setState(() => _currentUser = updatedUser);
      } else {
        print("LobbyScreen: Profile update returned null (404/Error)");
        // Don't auto-logout for network errors, it's annoying while debugging.
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: const Text("ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ (Offline Mode)"),
               action: SnackBarAction(label: "Retry", onPressed: _refreshProfile),
               duration: const Duration(seconds: 10),
             ),
           );
        }
        // if (mounted) _logout(); 
      }
    } catch (e) {
      print("LobbyScreen: Error refreshing profile: $e");
      if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text("Error: $e"),
               action: SnackBarAction(label: "Retry", onPressed: _refreshProfile),
             ),
           );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use a SafeArea only for top/bottom constraints if needed, but for a full screen game bg, 
    // we might want the bg to extend behind status bars. 
    // For now, we'll wrap the main content in SafeArea.
    // For now, we'll wrap the main content in SafeArea.
    final poseIndex = context.select<UserProvider, double>((p) => p.selectedPose);
    if (_poseInput != null && _poseInput!.value != poseIndex) {
       _poseInput!.value = poseIndex;
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Layer
          _buildBackground(),

          // 2. Main Content
          SafeArea(
            child: Stack(
              children: [
                // Character (Centered)
                Positioned.fill(
                  child: Center(
                    child: _buildCharacter(),
                  ),
                ),

                // Top Bar (Resources & Settings)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildTopBar(),
                ),

                // Right Side Menu (Achievements, Missions, etc.)
                Positioned(
                  right: 16,
                  top: 100, // pushed down below the top bar
                  child: _buildRightSideMenu(),
                ),

                // Bottom Navigation Menu
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: _buildBottomMenu(),
                ),
              ],
            ),
          ),
          
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    // Placeholder for a room/lobby background image
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.lightBlue.shade200,
            Colors.orange.shade100,
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.home, size: 200, color: Colors.white24), // Subtle bg icon
      ),
    );
  }

  Widget _buildCharacter() {
    // Rive Animation
    // Safely load Rive
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name Tag above head
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "${_currentUser.username} (Lv.${_currentUser.level})",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        // Character Animation
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (_tapInput != null) {
              _tapInput!.fire();
              print("User tapped character! Trigger fired.");
            } else {
              print("User tapped character! But _tapInput is NULL.");
              if (_controller != null) {
                 print("DEBUG: Available Inputs are -> ${_controller!.inputs.map((e) => e.name).toList()}"); 
                 print("Please check if your Rive input name matches one of these.");
              }
            }
          },
          child: Container(
            height: 500, // Adjusted size for cropped model
            width: 400,
            decoration: const BoxDecoration(
              color: Colors.transparent, 
            ),
            // Rive Animation
            child: Stack(
              alignment: Alignment.center,
              children: [
                 if (!_isRiveLoaded)
                   const Center(child: CircularProgressIndicator(color: Colors.white)),
                 
                 // Use Cached File if available for instant load
                 if (RiveCache().file != null) 
                   RiveAnimation.direct(
                      RiveCache().file!,
                      fit: BoxFit.contain,
                      antialiasing: false,
                      onInit: _onRiveInit,
                      stateMachines: const ['State Machine 1'], // Pre-specify to speed up
                   )
                 else 
                   RiveAnimation.asset(
                    'assets/animation/Model1110.riv', 
                    fit: BoxFit.contain,
                    antialiasing: false, 
                    onInit: _onRiveInit,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          // Resource Pills
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _resourcePill(Icons.monetization_on, "${_currentUser.coins}", Colors.blue),
                  const SizedBox(width: 8),
                  _resourcePill(Icons.local_activity, "${_currentUser.tickets}/7", Colors.pink), // x/Max
                  const SizedBox(width: 8),
                  _resourcePill(Icons.confirmation_number, "${_currentUser.vouchers}/3", Colors.amber),
                ],
              ),
            ),
          ),
          
          // Helper Buttons
          _circleIconButton(Icons.notifications, Colors.indigo, () {
             Navigator.pushNamed(context, '/notification');
          }),
          const SizedBox(width: 8),
          _circleIconButton(Icons.settings, Colors.blueGrey, () {
             Navigator.push(context, MaterialPageRoute(builder: (c) => SettingsScreen(user: _currentUser)));
          }),
        ],
      ),
    );
  }

  Widget _resourcePill(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton(IconData icon, Color bg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildRightSideMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _sideMenuButton("Achievement", Icons.emoji_events, Colors.amber, () {
          Navigator.pushNamed(context, '/achievement');
        }),
        const SizedBox(height: 12),
        _sideMenuButton("Quest", Icons.list_alt, Colors.blue, () {
           // Direct link to Quest Screen (if route exists or direct push)
           Navigator.pushNamed(context, '/quest');
        }),
        const SizedBox(height: 12),
        _sideMenuButton("Box", Icons.card_giftcard, Colors.purpleAccent, () {
           Navigator.pushNamed(context, '/lootbox');
        }),
      ],
    );
  }

  Widget _sideMenuButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label, 
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomMenu() {
    return Container(
      // Optional background for the menu bar
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.0), // Transparent container
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Using a larger Main Avatar button (Current User)
          _bottomMenuButton("Profile", Icons.face, Colors.teal, isLarge: true, onTap: () {
             Navigator.pushNamed(context, '/profile');
          }),

          _bottomMenuButton("Fashion", Icons.checkroom, Colors.pink, onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (c) => FashionScreen(user: _currentUser)));
          }),
          
          _bottomMenuButton("Dorm", Icons.bed, Colors.indigo, onTap: () {
            // Navigator.pushNamed(context, '/dorm');
          }),
          
          _bottomMenuButton("Map", Icons.map, Colors.redAccent, onTap: () {
             Navigator.pushNamed(context, '/map');
          }),
          
          _bottomMenuButton("Club", Icons.groups, Colors.orange, onTap: () {
             Navigator.pushNamed(context, '/club');
          }),
        ],
      ),
    );
  }

  Widget _bottomMenuButton(String label, IconData icon, Color color, {bool isLarge = false, required VoidCallback onTap}) {
    double size = isLarge ? 60 : 50;
    double iconSize = isLarge ? 35 : 28;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 3))],
            ),
            child: Icon(icon, color: color, size: iconSize),
          ),
          const SizedBox(height: 4),
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
             decoration: BoxDecoration(
               color: Colors.white.withOpacity(0.8),
               borderRadius: BorderRadius.circular(10),
             ),
             child: Text(label, style: TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
