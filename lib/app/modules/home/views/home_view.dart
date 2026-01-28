import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  static const List<Widget> _tabPages = [
    _HomeTab(),
    _ReportsTab(),
    _ManageTab(),
    _MoreTab(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: SafeArea(
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/header_image.png',
                  height: 48,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _colorBar(Colors.green),
                      _colorBar(Colors.lightGreen),
                      _colorBar(Colors.yellow),
                      _colorBar(Colors.orange),
                      _colorBar(Colors.red),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/1.jpg',
                  ),
                ),
                const SizedBox(width: 8),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_home.png',
              fit: BoxFit.cover,
            ),
          ),
          // Placeholder for selected tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _tabPages[_selectedIndex],
          ),
          // Custom Glassmorphic Bottom Navbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: _GlassNavbar(
              selectedIndex: _selectedIndex,
              onTabSelected: _onTabSelected,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper for color bar
Widget _colorBar(Color color) {
  return Container(
    width: 32,
    height: 16,
    margin: const EdgeInsets.symmetric(horizontal: 2),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

// Glassmorphic Bottom Navbar Widget
class _GlassNavbar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTabSelected;
  const _GlassNavbar({this.selectedIndex = 0, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/background_navbar.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.95,
              height: 70,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.18),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavBarItem(
                      icon: Icons.home,
                      label: 'Home',
                      selected: selectedIndex == 0,
                      onTap: () => onTabSelected(0),
                    ),
                    _NavBarDivider(),
                    _NavBarItem(
                      icon: Icons.article,
                      label: 'Reports',
                      selected: selectedIndex == 1,
                      onTap: () => onTabSelected(1),
                    ),
                    _NavBarDivider(),
                    _NavBarItem(
                      icon: Icons.laptop,
                      label: 'Manage',
                      selected: selectedIndex == 2,
                      onTap: () => onTabSelected(2),
                    ),
                    _NavBarDivider(),
                    _NavBarItem(
                      icon: Icons.more_horiz,
                      label: 'More',
                      selected: selectedIndex == 3,
                      onTap: () => onTabSelected(3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const _NavBarItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.white70,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder tab pages
class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Home Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ReportsTab extends StatelessWidget {
  const _ReportsTab();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Reports Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ManageTab extends StatelessWidget {
  const _ManageTab();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Manage Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _MoreTab extends StatelessWidget {
  const _MoreTab();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'More Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _NavBarDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withOpacity(0.18),
      margin: const EdgeInsets.symmetric(horizontal: 2),
    );
  }
}
