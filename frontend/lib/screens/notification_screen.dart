import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/lobby_screen.dart';
import '../widgets/custom_top_bar.dart';
import '../api_service.dart';
import '../screens/notification_details.dart';

class NotificationScreen extends StatefulWidget {
  final User? user;

  const NotificationScreen({super.key, this.user});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> notifications = [];
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    // TODO: Load notifications from API
    setState(() {
      notifications = [
        NotificationItem(
          id: '1',
          imagePath: 'lib/assets/quest_1_icon.png',
          title: 'เควส Normal ใกล้หมดเวลา!',
          description:
              'ภารกิจ “สรุปคณิตบทที่ 1” ของคุณจะหมดเวลาในอีก 1 ชั่วโมง',
          timestamp: '5 นาทีที่แล้ว',
          isRead: false,
        ),
        NotificationItem(
          id: '2',
          imagePath: 'lib/assets/acheivement_icon.png',
          title: 'ปลดล็อกความสำเร็จใหม่',
          description:
              'ยินดีด้วย! คุณปลดล็อก "นักวางแผนมือใหม่" แล้ว อย่าลืมเข้าไปรับ...',
          timestamp: '5 ชั่วโมงที่แล้ว',
          isRead: false,
        ),
        NotificationItem(
          id: '3',
          imagePath: 'lib/assets/club_1_icon.png',
          title: 'ภารกิจใหม่จากชมรม',
          description:
              'หัวหน้าชมรมได้สร้าง “เควสติวหนังสือ” เข้าไปทำเพื่อรับ 200...',
          timestamp: '7 ชั่วโมงที่แล้ว',
          isRead: false,
        ),
        NotificationItem(
          id: '4',
          imagePath: 'lib/assets/exam_icon.png',
          title: 'คุณพร้อมสอบแล้ว!',
          description: 'ค่าความสามารถของคุณถึงเกณฑ์แล้ว คุณสามารถใช้สิทธิเข้า...',
          timestamp: '5 ชั่วโมงที่แล้ว',
          isRead: false,
        ),
      ];
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        Positioned.fill(
          child: Image.asset('lib/assets/BG.png', fit: BoxFit.cover),
        ),

        _buildTopBar(),

        Padding(
          padding: const EdgeInsets.fromLTRB(24, 150, 24, 24),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 600,//ฟิกความสูงกล่องตรงนี้
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.82),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFAAD7EA),
                    width: 3,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Progress
                    Text(
                      'จำนวน 4/100',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ⭐ ListView scroll ได้ แต่กล่องไม่ยืด
                    Expanded(
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          return _buildNotificationCard(
                            context,
                            notifications[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              _buildHeaderTitle(),

              Positioned(
                bottom: 0,
                left: 20,
                right: 20,
                child: _buildBottomButtons(),
              ),
            ],
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
            color: Colors.black.withOpacity(0.4),
            child: CustomTopBar(
              user: widget.user,
              onNotificationTapped: () {
                // อยู่หน้า notification แล้ว
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
                    ? 'lib/assets/bt-hover-Back.png'
                    : 'lib/assets/bt-Back.png',
                width: 50,
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          // Progress indicator
          Text(
            'อ่านแล้ว 4/100',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 16),

          // Notification List
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return _buildNotificationCard(context, notifications[index]);
            },
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFEA4444),
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'ลบทั้งหมด',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF556AEB), Color(0xFF59ABEC)],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'เลือก',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

Widget _buildNotificationCard(BuildContext context, NotificationItem item) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFBADEEE).withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        // ICON
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              item.imagePath.isNotEmpty
                  ? item.imagePath
                  : 'lib/assets/placeholder.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.description.isNotEmpty ? item.description : '-',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Text(
          item.timestamp.isNotEmpty ? item.timestamp : '',
          style: const TextStyle(fontSize: 11),
        ),
      ],
    ),
  );
}


  Widget _buildHeaderTitle() {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionalTranslation(
        translation: const Offset(0, -0.5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2374B5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text(
            "แจ้งเตือน",
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

// Notification Item Model
class NotificationItem {
  final String id;
  final String imagePath;
  final String? title;
  final String description;
  final String timestamp;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isRead = false,
  });
}
