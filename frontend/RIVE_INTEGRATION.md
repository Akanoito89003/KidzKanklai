# คู่มือการย้ายระบบโมเดลอนิเมชั่น (Rive Animation Migration Guide) - ฉบับละเอียด

เอกสารฉบับนี้จัดทำขึ้นเพื่อช่วยให้คุณสามารถ Copy-Paste โค้ดที่จำเป็นไปยังโปรเจกต์ใหม่ได้ง่ายที่สุด โดยแบ่งเป็น 5 ขั้นตอนหลัก

---

## 🏗 **โครงสร้างในโปรเจกต์ใหม่ (Project Structure)**

เมื่อคุณย้ายไปโปรเจกต์ใหม่ ควรวางโครงสร้างไฟล์เบื้องต้นดังนี้:

```text
my_new_project/
├── assets/
│   └── animation/
│       └── Model1110.riv          <-- [1. ไฟล์โมเดล] Copy มาวางที่นี่
├── lib/
│   ├── utils/
│   │   └── rive_cache.dart        <-- [2. ไฟล์ Loading] สร้างไฟล์ใหม่ตามนี้
│   ├── providers/
│   │   └── user_pose_provider.dart <-- [3. ไฟล์จำท่าทาง] สร้างไฟล์ใหม่ตามนี้
│   └── screens/
│       └── character_widget.dart  <-- [4. ไฟล์แสดงผล] สร้าง Widget นี้เพื่อเรียกใช้ง่ายๆ
└── pubspec.yaml                   <-- [5. ไฟล์ตั้งค่า] แก้ไขเพื่อเพิ่ม rive และ assets
```

---

## 🛠 **ขั้นตอนที่ 1: แก้ไข pubspec.yaml**

เปิดไฟล์ `pubspec.yaml` ในโปรเจกต์ใหม่ แล้วเพิ่ม code 2 ส่วนนี้:

**1. เพิ่ม dependency ในส่วน dependencies:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  rive: ^0.13.0  # (เวอร์ชันอาจเปลี่ยนได้ตามความเหมาะสม)
  provider: ^6.0.0 # (จำเป็นสำหรับจัดการ State ท่าทาง)
```

**2. เปิดใช้งาน Assets ในส่วน flutter:**
```yaml
flutter:
  assets:
    - assets/animation/
```

> **อย่าลืม:** รันคำสั่ง `flutter pub get` หลังจากแก้ไฟล์เสร็จ

---

## ⚡ **ขั้นตอนที่ 2: สร้างไฟล์ Cache (rive_cache.dart)**

สร้างไฟล์ใหม่ที่ `lib/utils/rive_cache.dart` แล้ว Copy โค้ดด้านล่างไปใส่ทั้งหมด:

```dart
// ไฟล์: lib/utils/rive_cache.dart
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveCache {
  static final RiveCache _instance = RiveCache._internal();
  factory RiveCache() => _instance;
  RiveCache._internal();

  RiveFile? _file;
  bool _isLoading = false;

  /// เรียกใช้ฟังก์ชันนี้ที่ main.dart เพื่อโหลดโมเดลรอไว้ก่อน
  Future<void> loadAsset(String assetPath) async {
    if (_file != null) return;
    if (_isLoading) return;

    _isLoading = true;
    try {
      print("RiveCache: Start loading $assetPath...");
      await RiveFile.initialize(); // สำคัญมาก
      final data = await rootBundle.load(assetPath);
      _file = RiveFile.import(data);
      print("RiveCache: Successfully loaded Rive file!");
    } catch (e) {
      print("RiveCache: Error loading file: $e");
    } finally {
      _isLoading = false;
    }
  }

  RiveFile? get file => _file;
  bool get isLoaded => _file != null;
}
```

> **Tip:** ที่ไฟล์ `main.dart` ของโปรเจกต์ใหม่ ควรเพิ่มบรรทัดนี้ใน `void main()`:
> ```dart
> void main() async {
>   WidgetsFlutterBinding.ensureInitialized();
>   await RiveCache().loadAsset('assets/animation/Model1110.riv'); // โหลดรอไว้เลย
>   runApp(MyApp());
> }
> ```

---

## 🧘 **ขั้นตอนที่ 3: สร้างไฟล์ Providers (user_pose_provider.dart)**

ถ้าโปรเจกต์ใหม่ไม่มี User Model ก็ไม่เป็นไร ให้สร้าง Provider ง่ายๆ เพื่อเก็บท่าทางครับ
สร้างไฟล์ใหม่ที่ `lib/providers/user_pose_provider.dart`:

```dart
// ไฟล์: lib/providers/user_pose_provider.dart
import 'package:flutter/material.dart';

class UserPoseProvider extends ChangeNotifier {
  // ค่าเริ่มต้นท่าทาง (0 = ยืนเฉยๆ)
  double _selectedPose = 0; 
  
  double get selectedPose => _selectedPose;

  void setPose(double poseIndex) {
    _selectedPose = poseIndex;
    notifyListeners();
  }
}
```

> **อย่าลืม:** ไปครอบ `ChangeNotifierProvider` ที่ `main.dart` ด้วยนะครับ ไม่งั้นจะใช้งานไม่ได้

---

## 🎨 **ขั้นตอนที่ 4: สร้าง Widget แสดงตัวละคร (CharacterWidget)**

นี่คือหัวใจสำคัญครับ! ให้สร้างไฟล์ `lib/screens/character_widget.dart` ขึ้นมาเป็น Widget สำเร็จรูป เพื่อที่คุณจะได้เรียกใช้ `<CharacterWidget />` ที่หน้าไหนก็ได้

```dart
// ไฟล์: lib/screens/character_widget.dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:provider/provider.dart';
import '../utils/rive_cache.dart';           // เช็ค path ให้ถูก
import '../providers/user_pose_provider.dart'; // เช็ค path ให้ถูก

class CharacterWidget extends StatefulWidget {
  final double height;
  final double width;
  // ถ้าต้องการส่งค่าผม/หน้าตา มาบังคับเอง ก็เพิ่ม parameter ได้ตรงนี้
  final int? forceHairId; 

  const CharacterWidget({
    super.key, 
    this.height = 500, 
    this.width = 400,
    this.forceHairId,
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
      
      // หา Hair Input แบบยืดหยุ่น (ไม่สนใจตัวพิมพ์เล็กใหญ่)
      try {
        var hairInputRaw = controller.inputs.firstWhere(
           (e) => e.name.toLowerCase() == 'hairid' || e.name == 'Hair_ID', 
           orElse: () => controller!.inputs.first
        );
        if (hairInputRaw is SMINumber) _hairInput = hairInputRaw;
      } catch (_) {}

      // หา Tap Input
      try {
        var tapInputRaw = controller.inputs.firstWhere(
           (e) => e.name.toLowerCase().contains('tap'), 
           orElse: () => controller!.inputs.first
        );
        if (tapInputRaw is SMITrigger) _tapInput = tapInputRaw;
      } catch (_) {}

      // 1. ตั้งค่าผม (ถ้ามีการส่งมา)
      if (widget.forceHairId != null && _hairInput != null) {
         _hairInput!.value = widget.forceHairId!.toDouble();
      }
    }
    
    // แจ้งว่าโหลดเสร็จแล้ว
    if (mounted) setState(() => _isRiveLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    // 2. ดึงค่าท่าทางจาก Provider มาใส่ตลอดเวลา
    final poseIndex = context.select<UserPoseProvider, double>((p) => p.selectedPose);
    if (_poseInput != null && _poseInput!.value != poseIndex) {
       _poseInput!.value = poseIndex;
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
                'assets/animation/Model1110.riv', // <-- เช็คชื่อไฟล์ดีๆ
                fit: BoxFit.contain,
                antialiasing: false, 
                onInit: _onRiveInit,
             ),
             
           // Tap Area
           Positioned.fill(
             child: GestureDetector(
               onTap: () => _tapInput?.fire(),
               behavior: HitTestBehavior.translucent,
               child: Container(color: Colors.transparent),
             ),
           ),
        ],
      ),
    );
  }
}
```

---

## 💾 **ขั้นตอนที่ 5: Backend Data (Database)**

เพื่อให้ Frontend รู้ว่าต้องแสดงผลอะไร ฐานข้อมูลของคุณต้องเก็บค่าเหล่านี้:

| ชื่อคอลัมน์ (Column) | ประเภท (Type) | คำอธิบาย (Description) |
| :--- | :--- | :--- |
| `equipped_pose` | `int` | เลขท่าทาง (0,1,2...) เพื่อส่งเข้า `_poseInput` |
| `equipped_hair` | `string` / `int` | ถ้าเป็น String แบบ "Hair Style 1" ต้องเขียนโค้ดแปลงเป็นเลข 1 ก่อนส่งเข้า `_hairInput` |
| `rive_id` | `int` | (ในตาราง Items) เลข ID ที่ตรงกับในไฟล์ Rive เพื่อบอกว่าไอเทมชิ้นนี้คือเลขอะไร |

เสร็จเรียบร้อย! แค่ทำตาม 5 ขั้นตอนนี้ คุณก็จะมีโมเดล Rive ที่ขยับได้ในโปรเจกต์ใหม่ทันทีครับ
