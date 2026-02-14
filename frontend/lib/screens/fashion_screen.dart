import 'package:flutter/material.dart';
import '../api_service.dart';
import '../api_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:rive/rive.dart' hide LinearGradient, Image;
import '../utils/rive_cache.dart';

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
  String _selectedTab = "skin"; // skin, hair, face, pose
  SMINumber? _poseInput;
  SMINumber? _hairInput; 
  SMITrigger? _tapInput; // Trigger for tap interaction

  bool _isRiveLoaded = false;
  StateMachineController? _controller; 

  InventoryItem? _previewHairItem; 
  InventoryItem? _previewFaceItem;
  InventoryItem? _previewSkinItem;

  // Model animationController 
  void _onRiveInit(Artboard artboard) {
    var controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller == null && artboard.stateMachines.isNotEmpty) {
       controller = StateMachineController.fromArtboard(artboard, artboard.stateMachines.first.name);
    }

    if (controller != null) {
      artboard.addController(controller);
      _controller = controller;
      
      // Debug: Print all inputs to find the correct names
      print("FashionScreen: Available Inputs -> ${controller.inputs.map((e) => e.name).toList()}");

      _poseInput = controller.findInput<SMINumber>('Pose') as SMINumber?;
      
      // Fuzzy search for HairID
      try {
        var hairInputRaw = controller.inputs.firstWhere((e) => e.name.toLowerCase() == 'hairid' || e.name == 'Hair_ID', orElse: () => controller!.inputs.firstWhere((e) => e.name.contains('Hair'), orElse: () => controller!.inputs.first));
        if (hairInputRaw is SMINumber) {
           _hairInput = hairInputRaw;
           print("FashionScreen: Found Hair Input as '${hairInputRaw.name}'");
        }
      } catch (e) {
         print("FashionScreen: Could not fuzzy find HairID input");
      }

      // Fuzzy search for Tapcharacter
      try {
        var tapInputRaw = controller.inputs.firstWhere((e) => e.name.toLowerCase() == 'tapcharacter' || e.name.toLowerCase() == 'tap', orElse: () => controller!.inputs.firstWhere((e) => e is SMITrigger, orElse: () => controller!.inputs.first));
        if (tapInputRaw is SMITrigger) {
           _tapInput = tapInputRaw;
           print("FashionScreen: Found Tap Input as '${tapInputRaw.name}'");
        }
      } catch (e) {
         print("FashionScreen: Could not fuzzy find Tap input");
      }

      // Set initial pose from Provider
      final providerPose = Provider.of<UserProvider>(context, listen: false).selectedPose;
      if (_poseInput != null) {
        _poseInput!.value = providerPose;
      }
      
      // Sync Hair with User Profile (Initial)
      if (_hairInput != null && _currentUser.equippedHair.isNotEmpty) {
          // If User Profile has "Hair Style X"
          if (_currentUser.equippedHair.startsWith("Hair Style ")) {
             try {
                String numberPart = _currentUser.equippedHair.replaceAll("Hair Style ", "");
                int id = int.parse(numberPart);
                _hairInput!.value = id.toDouble();
                print("FashionScreen: Init HairID to $id (Current Value: ${_hairInput!.value})");
             } catch (e) {
                print("FashionScreen: Error parsing initial hair: $e");
             }
          } else if (_currentUser.equippedHair == "default_blue") {
             _hairInput!.value = 0;
          }
      }
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _isRiveLoaded = true);
    });
  }

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _fetchInventory();
  }
  
  Future<void> _fetchInventory() async {
    setState(() => _isLoading = true);
    final items = await ApiService.getInventory(_currentUser.id);

    // Sync initial selection with user's equipped items
    InventoryItem? currentHair;
    InventoryItem? currentFace;
    InventoryItem? currentSkin;

    // Helper to find item by name (assuming name is unique enough or best effort)
    try {
      if (_currentUser.equippedHair.isNotEmpty) {
         currentHair = items.firstWhere((i) => i.name == _currentUser.equippedHair && i.category == 'hair', orElse: () => items.firstWhere((i) => i.category == 'hair'));
      }
      if (_currentUser.equippedFace.isNotEmpty) {
         currentFace = items.firstWhere((i) => i.name == _currentUser.equippedFace && i.category == 'face', orElse: () => items.firstWhere((i) => i.category == 'face'));
      }
      if (_currentUser.equippedSkin.isNotEmpty) {
         currentSkin = items.firstWhere((i) => i.name == _currentUser.equippedSkin && i.category == 'skin', orElse: () => items.firstWhere((i) => i.category == 'skin'));
      }
    } catch (e) {
      print("FashionScreen: Error syncing initial selection: $e");
    }

    setState(() {
      _inventory = items;
      _previewHairItem = currentHair;
      _previewFaceItem = currentFace;
      _previewSkinItem = currentSkin;
      _isLoading = false;
    });
  }

  Future<void> _saveChanges() async {
    bool anySuccess = false;
    
    // Save Hair
    if (_previewHairItem != null) {
       final success = await ApiService.equipItem(_currentUser.id, "hair", _previewHairItem!.name);
       if (success) anySuccess = true;
    }
    // Save Face
    if (_previewFaceItem != null) {
       final success = await ApiService.equipItem(_currentUser.id, "face", _previewFaceItem!.name);
       if (success) anySuccess = true;
    }
    // Save Pose
    if (_poseInput != null) {
       final value = _poseInput!.value;
       context.read<UserProvider>().setPose(value);
       final success = await ApiService.equipItem(_currentUser.id, "pose", value.toString());
       if (success) anySuccess = true;
    }

    if (anySuccess) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Outfit Saved Successfully!")));
       
       // Update local user object to reflect changes (Optional but good for UI consistency)
       if (_previewHairItem != null) {
          _currentUser = User(
            id: _currentUser.id, username: _currentUser.username, email: _currentUser.email,
            level: _currentUser.level, exp: _currentUser.exp, coins: _currentUser.coins,
            tickets: _currentUser.tickets, vouchers: _currentUser.vouchers, bio: _currentUser.bio,
            soundBGM: _currentUser.soundBGM, soundSFX: _currentUser.soundSFX,
            equippedSkin: _currentUser.equippedSkin, 
            equippedHair: _previewHairItem!.name, 
            equippedFace: _currentUser.equippedFace,
            statIntellect: _currentUser.statIntellect, statStrength: _currentUser.statStrength, statCreativity: _currentUser.statCreativity,
            equippedPose: _currentUser.equippedPose
          );
       }
    } else {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No changes to save.")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fashion Studio"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle, size: 30, color: Colors.green),
            onPressed: _saveChanges,
            tooltip: "Save Outfit",
          )
        ],
      ),
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
                   GestureDetector(
                    onTap: () {
                      if (_tapInput != null) {
                         _tapInput!.fire();
                         print("FashionScreen: Character Tapped!");
                      }
                    },
                    child: SizedBox(
                      height: 280, 
                      width: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (!_isRiveLoaded)
                             const CircularProgressIndicator(),
                          
                          // Use Cached File if available
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
                              stateMachines: const ['State Machine 1'],
                            ),
                        ],
                      ),
                    ),
                   ),
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
                _buildTab("pose", "Pose"),
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
                  itemCount: _selectedTab == 'pose' ? 5 : _inventory.where((i) => i.category == _selectedTab).length,
                  itemBuilder: (context, index) {
                    if (_selectedTab == 'pose') {
                       return InkWell(
                        onTap: () {
                           context.read<UserProvider>().setPose(index.toDouble());
                           if (_poseInput != null) _poseInput!.value = index.toDouble();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.purple.shade300),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.accessibility_new, size: 40, color: Colors.purple),
                              const SizedBox(height: 5),
                              Text("Pose $index", textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    final items = _inventory.where((i) => i.category == _selectedTab).toList();
                    if (index >= items.length) return const SizedBox.shrink();
                    final item = items[index];

                    bool isSelected = (_previewHairItem?.id == item.id) || 
                                      (_previewFaceItem?.id == item.id) || 
                                      (_previewSkinItem?.id == item.id);

                    return InkWell(
                      onTap: () {
                        // Preview Visuals
                        if (_selectedTab == 'hair') {
                           if (_hairInput != null) {
                              _hairInput!.value = item.riveId.toDouble();
                           }
                           setState(() => _previewHairItem = item);
                        } else if (_selectedTab == 'face') {
                           setState(() => _previewFaceItem = item);
                        } else if (_selectedTab == 'skin') {
                           setState(() => _previewSkinItem = item);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey.shade300, 
                            width: isSelected ? 3 : 1
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  item.imagePath.startsWith('assets/') 
                                      ? item.imagePath 
                                      : 'assets/images/Fashion/HairStyle/${item.imagePath}',
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                            Text(item.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
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
