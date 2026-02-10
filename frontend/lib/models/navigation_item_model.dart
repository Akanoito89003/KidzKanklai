import 'package:flutter/material.dart';

class NavigationItem {
  final IconData icon;
  final String label;
  final Color color;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}

// Predefined navigation items
class NavigationItems {
  static const List<NavigationItem> bottomNavItems = [
    NavigationItem(
      icon: Icons.person,
      label: 'เพื่อน',
      color: Colors.blue,
    ),
    NavigationItem(
      icon: Icons.checkroom,
      label: 'ห้องแต่งตัว',
      color: Colors.pink,
    ),
    NavigationItem(
      icon: Icons.home,
      label: 'แผนที่',
      color: Colors.orange,
    ),
    NavigationItem(
      icon: Icons.group,
      label: 'ชมรม',
      color: Colors.purple,
    ),
  ];
}