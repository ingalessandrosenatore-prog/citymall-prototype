import 'package:flutter/material.dart';
import 'dart:ui';

import '../View/home/HomeView.dart';
import '../View/search/SearchView.dart'; // Placeholder

// import '../View/wishlist/WishlistView.dart'; // Placeholder

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _views = [
    const HomeView(),
    const Center(child: Text("Orders")), // Placeholder
    const Center(child: Text("Saved")), // Placeholder
    const SearchView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for glass effect
      body: IndexedStack(index: _currentIndex, children: _views),
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }

  Widget _buildCustomBottomNav() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), // Glass effect base
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, "Home"),
              _buildNavItem(1, Icons.shopping_bag_rounded, "Orders"),
              _buildNavItem(2, Icons.favorite_border_rounded, "Saved"),
              _buildNavItem(3, Icons.search_rounded, "Search"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    // Primary orange from CSS: #FF9F1C
    const primaryColor = Color(0xFFFF9F1C);

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: Matrix4.identity()..scale(isSelected ? 1.1 : 1.0),
            child: Icon(
              icon,
              color: isSelected ? primaryColor : Colors.blueGrey.shade400,
              size: 28,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? primaryColor : Colors.blueGrey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
