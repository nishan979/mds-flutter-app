import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/set_focus_goal_controller.dart';

class AddCustomGoalPage extends GetView<SetFocusGoalController> {
  final String category;
  const AddCustomGoalPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedHabit = 'Build skill';
    final habits = ['Build skill', 'Daily habit', 'Health', 'Wellbeing'];
    final freqOptions = ['Daily', 'Weekly', 'Monthly', 'One-Time'];
    final freqRx = 'Daily'.obs;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Add Custom Goal',
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
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
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Small steps towards big $category success.',
                    style: TextStyle(color: Colors.white54),
                  ),
                  SizedBox(height: 18.h),

                  Text('Goal Title', style: TextStyle(color: Colors.white54)),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C).withOpacity(0.35),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: TextField(
                      controller: titleCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your goal title...',
                        hintStyle: TextStyle(color: Colors.white24),
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),
                  Text(
                    'Goal Description (Optional)',
                    style: TextStyle(color: Colors.white54),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C).withOpacity(0.35),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          controller: descCtrl,
                          maxLines: 4,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter a brief description...',
                            hintStyle: TextStyle(color: Colors.white24),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '0 / 150',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),
                  Text('Goal Habit', style: TextStyle(color: Colors.white54)),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C).withOpacity(0.35),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: StatefulBuilder(
                        builder: (c, setState) {
                          return DropdownButton<String>(
                            value: selectedHabit,
                            dropdownColor: const Color(0xFF121212),
                            items: habits
                                .map(
                                  (h) => DropdownMenuItem(
                                    value: h,
                                    child: Text(
                                      h,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => selectedHabit = v);
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),
                  Text(
                    'Measure Frequency',
                    style: TextStyle(color: Colors.white54),
                  ),
                  SizedBox(height: 8.h),
                  Obx(
                    () => Row(
                      children: freqOptions.map((f) {
                        final sel = freqRx.value == f;
                        return GestureDetector(
                          onTap: () => freqRx.value = f,
                          child: Container(
                            margin: EdgeInsets.only(right: 8.w),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: sel
                                  ? const Color(0xFF2E2E4E)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: sel
                                    ? const Color(0xFFDEB988)
                                    : Colors.white24,
                              ),
                            ),
                            child: Text(
                              f,
                              style: TextStyle(
                                color: sel
                                    ? const Color(0xFFDEB988)
                                    : Colors.white70,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () {
                        final title = titleCtrl.text.trim();
                        if (title.isEmpty) {
                          Get.snackbar(
                            'Required',
                            'Please enter a goal title.',
                            backgroundColor: Colors.black.withOpacity(0.8),
                            colorText: Colors.white,
                          );
                          return;
                        }
                        controller.addCustomSupportingGoal(title);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2E2E6A), Color(0xFF1E1E4A)],
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'SAVE GOAL',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
