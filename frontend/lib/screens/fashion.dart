import 'dart:async';
import 'package:flutter/material.dart';

// =============================================================================
// PAGE WIDGET
// =============================================================================
class FashionPage extends StatefulWidget {
  const FashionPage({super.key});

  @override
  State<FashionPage> createState() => _FashionPageState();
}

class _FashionPageState extends State<FashionPage> {
  // --- STATE ---
  String selectedMainTab = FashionData.mainTabs[0];
  String selectedSubTab = FashionData.subTabs[0];
  int selectedItemIndex = 0;
  String selectedAge = 'Kid';
  int selectedSkinColorIndex = 0;

  // --- POPUP STATE ---
  String? _showingAgeText;
  double? _agePopupTop;
  Timer? _hideTimer;

  // --- EVENT HANDLERS ---
  void _onMainTabChanged(String tab) {
    setState(() => selectedMainTab = tab);
  }

  void _onSubTabChanged(String tab) {
    setState(() => selectedSubTab = tab);
  }

  void _onItemWithIndexSelected(int index) {
    setState(() => selectedItemIndex = index);
  }

  void _onSkinColorSelected(int index) {
    setState(() => selectedSkinColorIndex = index);
  }

  void _onAgeSelected(String ageType) {
    setState(() => selectedAge = ageType);
    _showAgePopup(ageType);
  }

  void _showAgePopup(String ageType) {
    String text = '';
    double top = 0;
    switch (ageType) {
      case 'Kid':
        text = 'เด็ก';
        top = 90 + 9;
        break;
      case 'Teen':
        text = 'วัยรุ่น';
        top = 148 + 9;
        break;
      case 'Adult':
        text = 'ผู้ใหญ่';
        top = 206 + 9;
        break;
    }

    _hideTimer?.cancel();
    setState(() {
      _showingAgeText = text;
      _agePopupTop = top;
    });

    _hideTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showingAgeText = null;
          _agePopupTop = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _FashionBackground(),
          const _FashionTopBar(),

          // Right Side Age Selector
          Positioned(
            top: 90,
            right: 10,
            child: _AgeSelector(
              selectedAge: selectedAge,
              onAgeSelected: _onAgeSelected,
            ),
          ),

          // Transient Popup
          if (_showingAgeText != null)
            _AgePopup(text: _showingAgeText!, top: _agePopupTop ?? 0),

          // Main Content
          Column(
            children: [
              // Character Area (Placeholder)
              const Expanded(flex: 4, child: SizedBox()),

              // Bottom Interactable Area
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _MainTabSelector(
                      tabs: FashionData.mainTabs,
                      selectedTab: selectedMainTab,
                      onTabSelected: _onMainTabChanged,
                    ),
                    Expanded(
                      child: _ContentArea(
                        selectedMainTab: selectedMainTab,
                        selectedSubTab: selectedSubTab,
                        selectedItemIndex: selectedItemIndex,
                        selectedSkinColorIndex: selectedSkinColorIndex,
                        onSubTabSelected: _onSubTabChanged,
                        onItemSelected: _onItemWithIndexSelected,
                        onSkinColorSelected: _onSkinColorSelected,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DATA & CONSTANTS
// =============================================================================
class FashionData {
  static const List<String> mainTabs = ['เสื้อผ้า', 'สีผิว', 'หน้าตา', 'ทรงผม'];
  static const List<String> subTabs = [
    'Grid',
    'Top',
    'Bottom',
    'Dress',
    'Shoes',
  ];

  static const List<Color> skinColors = [
    Color(0xFFFEEBDB),
    Color(0xFFFBCCAE),
    Color(0xFFFEBE86),
    Color(0xFFD08B50),
  ];

  static const List<Map<String, String>> items = [
    {'image': 'top-fashion-design1.png', 'name': 'ชุดนักเรียน'},
    {'image': 'top-fashion-design2.png', 'name': 'ชุดเดรส'},
    {'image': 'top-fashion-design3.png', 'name': 'ชุดแขนยาวลายทาง'},
    {'image': 'top-fashion-design4.png', 'name': 'ชุดเอี๊ยมลายดอก'},
  ];
}

// =============================================================================
// SUB-WIDGETS
// =============================================================================

class _FashionBackground extends StatelessWidget {
  const _FashionBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset('assets/images/bgFashion.png', fit: BoxFit.cover),
    );
  }
}

class _FashionTopBar extends StatelessWidget {
  const _FashionTopBar();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(height: 75, color: Colors.black.withOpacity(0.4)),
    );
  }
}

class _AgeSelector extends StatelessWidget {
  final String selectedAge;
  final ValueChanged<String> onAgeSelected;

  const _AgeSelector({required this.selectedAge, required this.onAgeSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildButton('Kid', 'assets/images/icon-kid.png'),
        const SizedBox(height: 8),
        _buildButton('Teen', 'assets/images/icon-teen.png'),
        const SizedBox(height: 8),
        _buildButton('Adult', 'assets/images/icon-adult.png'),
      ],
    );
  }

  Widget _buildButton(String ageType, String assetPath) {
    final isSelected = selectedAge == ageType;
    return GestureDetector(
      onTap: () => onAgeSelected(ageType),
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF556CEB), Color(0xFF58A9EC)],
          ),
          border: Border.all(
            color: Colors.white,
            width: isSelected ? 10.0 : 3.0,
          ),
        ),
        child: SizedBox(
          width: 35,
          height: 35,
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _AgePopup extends StatelessWidget {
  final String text;
  final double top;

  const _AgePopup({required this.text, required this.top});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: 70, // To the left of the buttons
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _MainTabSelector extends StatelessWidget {
  final List<String> tabs;
  final String selectedTab;
  final ValueChanged<String> onTabSelected;

  const _MainTabSelector({
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tabs.map((tab) {
          final isSelected = selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(tab),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF002A50) : null,
                  gradient: isSelected
                      ? null
                      : const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF556CEB), Color(0xFF58A9EC)],
                        ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  tab,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ContentArea extends StatelessWidget {
  final String selectedMainTab;
  final String selectedSubTab;
  final int selectedItemIndex;
  final int selectedSkinColorIndex;
  final ValueChanged<String> onSubTabSelected;
  final ValueChanged<int> onItemSelected;
  final ValueChanged<int> onSkinColorSelected;

  const _ContentArea({
    required this.selectedMainTab,
    required this.selectedSubTab,
    required this.selectedItemIndex,
    required this.selectedSkinColorIndex,
    required this.onSubTabSelected,
    required this.onItemSelected,
    required this.onSkinColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFD0E8F2).withOpacity(0.9),
        border: const Border(top: BorderSide(color: Colors.black, width: 2)),
      ),
      child: Column(
        children: [
          // Sub-Tabs (Conditionally rendered)
          if (selectedMainTab != 'สีผิว')
            _SubTabSelector(
              tabs: FashionData.subTabs,
              selectedTab: selectedSubTab,
              onTabSelected: onSubTabSelected,
            ),

          // Main Content Grid/List
          Expanded(
            child: selectedMainTab == 'สีผิว'
                ? _SkinColorSelector(
                    colors: FashionData.skinColors,
                    selectedIndex: selectedSkinColorIndex,
                    onColorSelected: onSkinColorSelected,
                  )
                : _FashionGrid(
                    items: FashionData.items,
                    selectedIndex: selectedItemIndex,
                    onItemSelected: onItemSelected,
                  ),
          ),
        ],
      ),
    );
  }
}

class _SubTabSelector extends StatelessWidget {
  final List<String> tabs;
  final String selectedTab;
  final ValueChanged<String> onTabSelected;

  const _SubTabSelector({
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: tabs.map((tab) => _buildIcon(tab)).toList(),
      ),
    );
  }

  Widget _buildIcon(String tab) {
    final isSelected = selectedTab == tab;
    String iconAsset = 'assets/images/all-fashion.png';

    switch (tab) {
      case 'Grid':
        iconAsset = 'assets/images/all-fashion.png';
        break;
      case 'Top':
        iconAsset = 'assets/images/top-fashion.png';
        break;
      case 'Bottom':
        iconAsset = 'assets/images/botton-fashion.png';
        break;
      case 'Dress':
        iconAsset = 'assets/images/dress-fashion.png';
        break;
      case 'Shoes':
        iconAsset = 'assets/images/shoe-fashion.png';
        break;
    }

    return GestureDetector(
      onTap: () => onTabSelected(tab),
      child: Container(
        width: 45,
        height: 45,
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF556AEB), Color(0xFF66E0FF)],
                )
              : null,
          color: isSelected ? null : Colors.white,
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFF5C9DFF), width: 2),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Color(0xFF4AC4F3),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Image.asset(iconAsset, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _FashionGrid extends StatelessWidget {
  final List<Map<String, String>> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const _FashionGrid({
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, idx) => _ItemCard(
        item: items[idx],
        isSelected: selectedIndex == idx,
        onTap: () => onItemSelected(idx),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final Map<String, String> item;
  final bool isSelected;
  final VoidCallback onTap;

  const _ItemCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFCEFFB2), Color(0xFF6FBBDE)],
                )
              : null,
          color: isSelected ? null : const Color(0xFFAAD7EA),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  // Icon Top Right
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFC8E5F1),
                            width: 1.5,
                          ),
                        ),
                        child: Image.asset('assets/images/dress-fashion.png'),
                      ),
                    ),
                  ),

                  // Main Image
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Image.asset(
                          'assets/images/${item['image']}',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // Text Name
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8.0,
                      top: 4.0,
                      left: 4,
                      right: 4,
                    ),
                    child: Text(
                      item['name']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (isSelected)
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
              if (isSelected)
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFCEFFB2), Color(0xFF70BCDE)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkinColorSelector extends StatelessWidget {
  final List<Color> colors;
  final int selectedIndex;
  final ValueChanged<int> onColorSelected;

  const _SkinColorSelector({
    required this.colors,
    required this.selectedIndex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40),
      alignment: Alignment.topCenter,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20,
        children: List.generate(colors.length, (index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onColorSelected(index),
            child: Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFCEFFB2), Color(0xFF70BCDE)],
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                border: isSelected
                    ? null
                    : Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                ),
                child: isSelected
                    ? const Center(
                        child: Icon(Icons.check, color: Colors.white, size: 30),
                      )
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}
