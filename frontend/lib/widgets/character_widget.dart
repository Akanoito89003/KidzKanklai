// ไฟล์: lib/screens/character_widget.dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:provider/provider.dart';
import '../config/rive_cache.dart';           // เช็ค path ให้ถูก
import '../config/user_pose_provider.dart'; // เช็ค path ให้ถูก

import '../api_service.dart'; // Import User model

class CharacterWidget extends StatefulWidget {
  final double height;
  final double width;
  final User? user; // Accept User object

  const CharacterWidget({
    super.key, 
    this.height = 500, 
    this.width = 400,
    this.user,
  });

  @override
  State<CharacterWidget> createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<CharacterWidget> {
  StateMachineController? _controller;
  SMINumber? _poseInput;
  SMINumber? _hairInput;
  SMITrigger? _tapInput;
  bool _isRiveLoaded = false;

  void _onRiveInit(Artboard artboard) {
    var controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller == null && artboard.stateMachines.isNotEmpty) {
       controller = StateMachineController.fromArtboard(artboard, artboard.stateMachines.first.name);
    }

    if (controller != null) {
      artboard.addController(controller);
      _controller = controller;

      _poseInput = controller.findInput<SMINumber>('Pose') as SMINumber?;
      
      // Fuzzy match HairID
      try {
        var hairInputRaw = controller.inputs.firstWhere(
           (e) => e.name.toLowerCase() == 'hairid' || e.name == 'Hair_ID', 
           orElse: () => controller!.inputs.first
        );
        if (hairInputRaw is SMINumber) _hairInput = hairInputRaw;
      } catch (_) {}

      // Fuzzy match Tap
      try {
        var tapInputRaw = controller.inputs.firstWhere(
           (e) => e.name.toLowerCase().contains('tap'), 
           orElse: () => controller!.inputs.first
        );
        if (tapInputRaw is SMITrigger) _tapInput = tapInputRaw;
      } catch (_) {}

      // Apply User's Equipped Items
      if (widget.user != null && _hairInput != null) {
         if (widget.user!.equippedHair.isNotEmpty) {
            String hairStr = widget.user!.equippedHair;
            if (hairStr.startsWith("Hair Style ")) {
               try {
                  int id = int.parse(hairStr.replaceAll("Hair Style ", ""));
                  _hairInput!.value = id.toDouble();
               } catch (e) {}
            } else if (hairStr == "default_blue") {
               _hairInput!.value = 0;
            }
            // Add more parsing logic if needed
         }
      }
    }
    
    if (mounted) setState(() => _isRiveLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    // 2. ดึงค่า Emotion จาก Provider มาใส่ Rive Input 'Pose'
    final emotionIndex = context.select<UserPoseProvider, double>((p) => p.currentEmotion);
    if (_poseInput != null && _poseInput!.value != emotionIndex) {
       _poseInput!.value = emotionIndex;
    }

    // 3. ตรวจสอบ Trigger Reaction
    final shouldTrigger = context.select<UserPoseProvider, bool>((p) => p.shouldTriggerReaction);
    if (shouldTrigger && _tapInput != null) {
       _tapInput!.fire();
    }

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
           // Loading Indicator
           if (!_isRiveLoaded) const CircularProgressIndicator(),

           // Rive Animation Logic
           if (RiveCache().file != null) 
             RiveAnimation.direct(
                RiveCache().file!,
                fit: BoxFit.contain,
                antialiasing: false,
                onInit: _onRiveInit,
                stateMachines: const ['State Machine 1'],
             )
           else 
             RiveAnimation.asset(
                'assets/animation/Model1110.riv', 
                fit: BoxFit.contain,
                antialiasing: false, 
                onInit: _onRiveInit,
             ),
             
           // Tap Area -> Trigger Reaction
           Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  context.read<UserPoseProvider>().triggerReaction();
                },
               behavior: HitTestBehavior.translucent,
               child: Container(color: Colors.transparent),
             ),
           ),
        ],
      ),
    );
  }
}