import 'dart:async';
import 'package:flutter/material.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  Timer? _timer;
  int _secondsRemaining = 1500; // 25 minutes default
  bool _isRunning = false;

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _stopTimer();
        // Trigger completion logic here
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Quest Completed!")));
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _stopTimer();
    setState(() => _secondsRemaining = 1500);
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Quests")),
      body: Container(
         width: double.infinity,
         decoration: BoxDecoration(
           color: Colors.blue.shade50
         ),
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("CURRENT QUEST", style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]
              ),
              child: Text(
                _formatTime(_secondsRemaining),
                style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning)
                  ElevatedButton(
                    onPressed: _startTimer,
                     style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("START", style: TextStyle(color: Colors.white)),
                  )
                else
                  ElevatedButton(
                    onPressed: _stopTimer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text("PAUSE", style: TextStyle(color: Colors.white)),
                  ),
                const SizedBox(width: 20),
                TextButton(onPressed: _resetTimer, child: const Text("Reset")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
