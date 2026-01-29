// ignore_for_file: unused_element

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/storage/storage_service.dart';

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
                  height: 30.h,
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
                  radius: 18.r,
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/background_navbar.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 70.h,
            ),
            // Overlay labels (placed below the icons in the background image)
            Positioned.fill(
              child: Container(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 32.h, left: 10.w, right: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavLabelItem(
                        label: 'Home',
                        selected: selectedIndex == 0,
                        onTap: () => onTabSelected(0),
                      ),
                      _NavLabelItem(
                        label: 'Reports',
                        selected: selectedIndex == 1,
                        onTap: () => onTabSelected(1),
                      ),
                      _NavLabelItem(
                        label: 'Manage',
                        selected: selectedIndex == 2,
                        onTap: () => onTabSelected(2),
                      ),
                      _NavLabelItem(
                        label: 'More',
                        selected: selectedIndex == 3,
                        onTap: () => onTabSelected(3),
                      ),
                    ],
                  ),
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
    final storage = Get.find<StorageService>();
    final name = (storage.user != null && storage.user!['name'] != null)
        ? (storage.user!['name'] as String)
        : 'Zachary';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100.h),
              Text(
                'Welcome back,',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textWhite.withAlpha(220),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                name,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textWhite,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Let's take back your attention and your freedom.",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textWhite.withAlpha(180),
                ),
              ),
            ],
          ),
        ),
        // Scrollable feature list (only these 5 items scroll)
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 8.h),
                _FeatureCard(
                  icon: Icons.school,
                  title: 'Take Anti-SMUB Test',
                  subtitle: 'Assess your digital dependency',
                  onTap: () {},
                ),
                _FeatureCard(
                  icon: Icons.center_focus_strong,
                  title: 'Focus Mode',
                  subtitle: 'Control your wins and success',
                  onTap: () {},
                ),
                _FeatureCard(
                  icon: Icons.flag,
                  title: 'Set Focus Goal',
                  subtitle: 'Start breaking free today',
                  onTap: () {},
                ),
                _FeatureCard(
                  icon: Icons.emoji_events,
                  title: 'Daily Challenge',
                  subtitle: 'Improve your SMUB score',
                  onTap: () {},
                ),
                _FeatureCard(
                  icon: Icons.restore,
                  title: 'Recovery Task',
                  subtitle: 'Where and why you fall short',
                  onTap: () {},
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),

        // Fixed progress card (stays below scroll)
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          child: _ProgressCard(
            title: 'Understand the Trap',
            subtitle: "Learn how you're being manipulated",
            hoursText: '4h 15m / 5h',
            progress: 0.83,
          ),
        ),
        SizedBox(height: 85.h),
      ],
    );
  }
}

// Feature card used in home list
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(14.h),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(10),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withAlpha(50)),
          ),
          child: Row(
            children: [
              Container(
                width: 48.h,
                height: 48.h,
                decoration: BoxDecoration(
                  color: Color(0xFF3a4755),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: Color(0xFFecdab7), size: 26.h),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textWhite.withAlpha(180),
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textWhite.withAlpha(180),
                size: 28.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String hoursText;
  final double progress;
  const _ProgressCard({
    required this.title,
    required this.subtitle,
    required this.hoursText,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withAlpha(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textWhite.withAlpha(180),
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  hoursText,
                  style: TextStyle(
                    color: AppColors.textWhite.withAlpha(160),
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                LinearProgressIndicator(
                  value: progress,
                  color: Color(0xFFc2c9d2),
                  backgroundColor: Colors.white.withAlpha(20),
                  minHeight: 6.h,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 70.h,
            height: 70.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70.h,
                  height: 70.h,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8.h,
                    color: Color(0xFFc2c9d2),
                    backgroundColor: Colors.white.withAlpha(12),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
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

class _NavLabelItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const _NavLabelItem({required this.label, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          height: 60.h,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
            ),
          ),
        ),
      ),
    );
  }
}
