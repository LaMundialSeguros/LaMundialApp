// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomBottomNavigationBarItem extends StatelessWidget {
  final Icon icon;
  final String label;
  final bool isSelected;

  const CustomBottomNavigationBarItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
  return Container(
  decoration: BoxDecoration(
  color: isSelected ? Colors.blue : Colors.transparent,
  borderRadius: BorderRadius.circular(10),

  ),
  child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
  icon,
  Text(label),
  ],
  ),
  );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final List<CustomBottomNavigationBarItem> items;
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return BottomNavigationBar(

    items: items.map((item) => BottomNavigationBarItem(
      icon: item.icon,
      label: item.label,
    )).toList(),
    currentIndex: currentIndex,
    onTap: onTap,
    );
  }
}


