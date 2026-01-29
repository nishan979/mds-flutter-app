import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        preferredSize: Size.fromHeight(90.h),
        child: SafeArea(
          child: Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/header_image.png',
                  height: 48.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 16.w),
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
                  radius: 22.r,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/1.jpg',
                  ),
                ),
                SizedBox(width: 8.w),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 28.w,
                      ),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 8.w,
                      top: 8.h,
                      child: Container(
                        width: 16.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8.w),
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white, size: 24.w),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Logout',
                          style: TextStyle(fontSize: 18.sp),
                        ),
                        content: Text(
                          'Are you sure you want to logout?',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              'Logout',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      // Delegate actual logout logic to HomeController (shows snackbars & navigates)
                      try {
                        final homeCtrl = Get.find<HomeController>();
                        await homeCtrl.logout();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Logout failed',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        );
                      }
                    }
                  },
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
            padding: EdgeInsets.all(10.w),
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
    width: 24.w,
    height: 10.h,
    margin: EdgeInsets.symmetric(horizontal: 1.5.w),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(2.r),
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
        borderRadius: BorderRadius.circular(32.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/background_navbar.png',
              fit: BoxFit.cover,
              width: 0.95.sw,
              height: 70.h,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                width: 0.95.sw,
                height: 70.h,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(33),
                  borderRadius: BorderRadius.circular(32.r),
                  border: Border.all(
                    color: Colors.white.withAlpha(46),
                    width: 1.5.w,
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
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.white70,
              size: 28.w,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                shadows: [
                  Shadow(
                    color: Colors.black.withAlpha(51),
                    blurRadius: 2.r,
                    offset: Offset(0, 1.h),
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
    return Center(
      child: Text(
        'Home Page',
        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ReportsTab extends StatelessWidget {
  const _ReportsTab();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Reports Page',
        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ManageTab extends StatelessWidget {
  const _ManageTab();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Manage Page',
        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _MoreTab extends StatelessWidget {
  const _MoreTab();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'More Page',
        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _NavBarDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: 36.h,
      color: Colors.white.withAlpha(46),
      margin: EdgeInsets.symmetric(horizontal: 2.w),
    );
  }
}
