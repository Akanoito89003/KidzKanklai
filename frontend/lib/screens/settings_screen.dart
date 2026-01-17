import 'package:flutter/material.dart';
import '../api_service.dart';

class SettingsScreen extends StatefulWidget {
  final User user;
  const SettingsScreen({super.key, required this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _bgmVolume = 50;
  double _sfxVolume = 50;

  @override
  void initState() {
    super.initState();
    _bgmVolume = widget.user.soundBGM.toDouble();
    _sfxVolume = widget.user.soundSFX.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const ListTile(
               leading: Icon(Icons.person),
               title: Text("Account"),
               subtitle: Text("Manage your profile settings"),
               trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            const Divider(),
            const SizedBox(height: 20),
            const Text("Audio Settings", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.music_note),
                const SizedBox(width: 10),
                const Text("BGM"),
                Expanded(
                  child: Slider(
                    value: _bgmVolume, 
                    min: 0, max: 100, 
                    onChanged: (v) => setState(() => _bgmVolume = v),
                  ),
                ),
                Text("${_bgmVolume.toInt()}%"),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.volume_up),
                const SizedBox(width: 10),
                const Text("SFX"),
                Expanded(
                  child: Slider(
                    value: _sfxVolume, 
                    min: 0, max: 100, 
                    onChanged: (v) => setState(() => _sfxVolume = v),
                  ),
                ),
                Text("${_sfxVolume.toInt()}%"),
              ],
            ),
             const SizedBox(height: 40),
             SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                 onPressed: () {
                   // TODO: Save settings to backend
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Settings Saved")));
                   Navigator.pop(context);
                 },
                 child: const Text("Save Changes"),
               ),
             ),
             const SizedBox(height: 10),
             SizedBox(
               width: double.infinity,
               child: TextButton(
                 onPressed: () {
                   // Logout logic
                   Navigator.popUntil(context, (route) => route.isFirst);
                   // Navigate to login (requires route setup usually, but for now pop works if login is root)
                 },
                 child: const Text("Log Out", style: TextStyle(color: Colors.red)),
               ),
             )
          ],
        ),
      ),
    );
  }
}
