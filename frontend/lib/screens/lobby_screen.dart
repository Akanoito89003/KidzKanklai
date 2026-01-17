import 'package:flutter/material.dart';
import '../api_service.dart';
import 'login_screen.dart';
import 'fashion_screen.dart';
import 'quest_screen.dart';
import 'settings_screen.dart';

class LobbyScreen extends StatefulWidget {
  final User user;
  const LobbyScreen({super.key, required this.user});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late User _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _refreshProfile();
  }

  Future<void> _refreshProfile() async {
    setState(() => _isLoading = true);
    final updatedUser = await ApiService.getProfile(_currentUser.id);
    if (updatedUser != null) {
      setState(() => _currentUser = updatedUser);
    }
    setState(() => _isLoading = false);
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lobby: ${_currentUser.username}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), 
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (c) => SettingsScreen(user: _currentUser))
              );
            }
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshProfile),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Character Image Simulation
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 4),
                      ),
                      child: Icon(Icons.person, size: 100, color: Colors.blue.shade700),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildStatCard(),
                  const SizedBox(height: 20),
                  _buildAppearanceCard(),
                  const SizedBox(height: 20),
                  
                  const Text("Menu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      _menuButton(Icons.checkroom, "Fashion", Colors.pink, () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => FashionScreen(user: _currentUser)));
                      }),
                      _menuButton(Icons.list_alt, "Quest", Colors.orange, () {
                         Navigator.pushNamed(context, '/quest');
                      }),
                      _menuButton(Icons.timer, "Countdown", Colors.blueGrey, () {
                        Navigator.pushNamed(context, '/countdown');
                      }),
                      _menuButton(Icons.person, "Profile", Colors.blue, () {
                        Navigator.pushNamed(context, '/profile');
                      }),
                      _menuButton(Icons.notifications, "Notifications", Colors.red, () {
                        Navigator.pushNamed(context, '/notification');
                      }),
                      _menuButton(Icons.emoji_events, "Achievement", Colors.amber, () {
                        Navigator.pushNamed(context, '/achievement');
                      }),
                      _menuButton(Icons.card_giftcard, "Lootbox", Colors.purpleAccent, () {
                        Navigator.pushNamed(context, '/lootbox');
                      }),
                      _menuButton(Icons.map, "Map", Colors.green, () {
                        Navigator.pushNamed(context, '/map');
                      }),
                      _menuButton(Icons.group, "Club", Colors.teal, () {
                        Navigator.pushNamed(context, '/club');
                      }),                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _menuButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Level ${_currentUser.level}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Chip(
                  label: Text("${_currentUser.exp} EXP"), 
                  backgroundColor: Colors.blue.shade100,
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem("Coins", _currentUser.coins.toString(), Icons.monetization_on, Colors.amber),
                _statItem("Tickets", _currentUser.tickets.toString(), Icons.local_activity, Colors.redAccent),
                _statItem("Vouchers", _currentUser.vouchers.toString(), Icons.confirmation_number, Colors.green),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildAppearanceCard() {
    return Card(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Currently Equipped", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.accessibility),
              title: const Text("Skin"),
              trailing: Text(_currentUser.equippedSkin),
            ),
            ListTile(
              leading: const Icon(Icons.face),
              title: const Text("Face"),
              trailing: Text(_currentUser.equippedFace),
            ),
            ListTile(
              leading: const Icon(Icons.content_cut),
              title: const Text("Hair"),
              trailing: Text(_currentUser.equippedHair),
            ),
          ],
        ),
      ),
    );
  }
}
