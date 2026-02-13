import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_service.dart';

class FashionScreen extends StatefulWidget {
  final User user;
  const FashionScreen({super.key, required this.user});

  @override
  State<FashionScreen> createState() => _FashionScreenState();
}

class _FashionScreenState extends State<FashionScreen> {
  late User _currentUser;
  List<InventoryItem> _inventory = [];
  bool _isLoading = true;
  String _selectedTab = "skin"; // skin, hair, face

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _fetchInventory();
  }

  Future<void> _fetchInventory() async {
    setState(() => _isLoading = true);
    final items = await ApiService.getInventory(_currentUser.id);
    setState(() {
      _inventory = items;
      _isLoading = false;
    });
  }

  Future<void> _equipItem(String type, String itemId) async {
    final success = await ApiService.equipItem(_currentUser.id, type, itemId);
    if (success) {
      // Update local user state to reflect change immediately
      setState(() {
        if (type == "skin") {
          _currentUser = User(
            id: _currentUser.id,
            username: _currentUser.username,
            email: _currentUser.email,
            level: _currentUser.level,
            exp: _currentUser.exp,
            coins: _currentUser.coins,
            tickets: _currentUser.tickets,
            vouchers: _currentUser.vouchers,
            bio: _currentUser.bio,
            soundBGM: _currentUser.soundBGM,
            soundSFX: _currentUser.soundSFX,
            equippedSkin: itemId, // Updated
            equippedHair: _currentUser.equippedHair,
            equippedFace: _currentUser.equippedFace,
            statIntellect: _currentUser.statIntellect,
            statStrength: _currentUser.statStrength,
            statCreativity: _currentUser.statCreativity,
          );
        } else if (type == "hair") {
           _currentUser = User(
            id: _currentUser.id,
            username: _currentUser.username,
            email: _currentUser.email,
            level: _currentUser.level,
            exp: _currentUser.exp,
            coins: _currentUser.coins,
            tickets: _currentUser.tickets,
            vouchers: _currentUser.vouchers,
            bio: _currentUser.bio,
            soundBGM: _currentUser.soundBGM,
            soundSFX: _currentUser.soundSFX,
            equippedSkin: _currentUser.equippedSkin,
            equippedHair: itemId, // Updated
            equippedFace: _currentUser.equippedFace,
            statIntellect: _currentUser.statIntellect,
            statStrength: _currentUser.statStrength,
            statCreativity: _currentUser.statCreativity,
          );
        } else if (type == "face") {
           _currentUser = User(
            id: _currentUser.id,
            username: _currentUser.username,
            email: _currentUser.email,
            level: _currentUser.level,
            exp: _currentUser.exp,
            coins: _currentUser.coins,
            tickets: _currentUser.tickets,
            vouchers: _currentUser.vouchers,
            bio: _currentUser.bio,
            soundBGM: _currentUser.soundBGM,
            soundSFX: _currentUser.soundSFX,
            equippedSkin: _currentUser.equippedSkin,
            equippedHair: _currentUser.equippedHair,
            equippedFace: itemId, // Updated
            statIntellect: _currentUser.statIntellect,
            statStrength: _currentUser.statStrength,
            statCreativity: _currentUser.statCreativity,
          );
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Equipped!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to equip")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fashion Studio")),
      body: Column(
        children: [
          // 1. Character Preview (Top)
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: Colors.blue.shade50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 150, color: Colors.blue.shade800),
                  const SizedBox(height: 10),
                  Text("Skin: ${_currentUser.equippedSkin}"),
                  Text("Hair: ${_currentUser.equippedHair}"),
                  Text("Face: ${_currentUser.equippedFace}"),
                ],
              ),
            ),
          ),

          // 2. Tabs (Middle)
          Container(
            color: Colors.white,
            child: Row(
              children: [
                _buildTab("skin", "Skin"),
                _buildTab("hair", "Hair"),
                _buildTab("face", "Face"),
              ],
            ),
          ),

          // 3. Grid (Bottom)
          Expanded(
            flex: 5,
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _inventory.where((i) => i.type == _selectedTab).length,
                  itemBuilder: (context, index) {
                    final item = _inventory.where((i) => i.type == _selectedTab).toList()[index];
                    return InkWell(
                      onTap: () => _equipItem(item.type, item.id),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.checkroom, size: 40),
                            const SizedBox(height: 5),
                            Text(item.id, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String key, String label) {
    bool isSelected = _selectedTab == key;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: isSelected ? Colors.blue : Colors.transparent, width: 3)),
          ),
          child: Text(
            label, 
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
