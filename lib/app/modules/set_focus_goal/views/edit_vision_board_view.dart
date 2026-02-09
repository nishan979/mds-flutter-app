import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/set_focus_goal_controller.dart';

class EditVisionBoardView extends GetView<SetFocusGoalController> {
  const EditVisionBoardView({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Edit Vision Board',
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visualize your goals & fuel your journey.',
                    style: TextStyle(color: Colors.white54, fontSize: 14.sp),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    '"Build your vision. Master your attention. Live your purpose."',
                    style: TextStyle(
                      color: Colors.white38,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Big vision card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C).withOpacity(0.35),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Obx(() {
                            final path = controller.visionImagePath.value;
                            if (path.isEmpty) {
                              return Icon(
                                Icons.image,
                                color: const Color(0xFFDEB988).withOpacity(0.6),
                                size: 120.sp,
                              );
                            }
                            return Image.asset(
                              path,
                              width: 120.sp,
                              height: 80.h,
                              fit: BoxFit.cover,
                            );
                          }),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                controller.selectedIdentity.value.isEmpty
                                    ? 'A successful entrepreneur'
                                    : controller.selectedIdentity.value,
                                style: TextStyle(
                                  color: const Color(0xFFDEB988),
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              height: 80.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: Colors.transparent,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Add widgets to build your board.',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 18.h),

                  Text(
                    'Add Widgets',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Buttons grid
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: [
                      _actionTile(
                        icon: Icons.photo_library,
                        label: 'Image from Library',
                        onTap: () {
                          // stub: in real app use image picker
                          controller.addVisionWidget('image', 'from_library');
                        },
                      ),
                      _actionTile(
                        icon: Icons.star,
                        label: 'Icon from Library',
                        onTap: () {
                          controller.addVisionWidget('icon', 'from_library');
                        },
                      ),
                      _actionTile(
                        icon: Icons.format_quote,
                        label: 'Quote Template',
                        onTap: () {
                          controller.addVisionWidget('quote', 'template_1');
                        },
                      ),
                      _actionTile(
                        icon: Icons.text_fields,
                        label: 'Text Box',
                        onTap: () {
                          controller.addVisionWidget('text', 'custom_text');
                        },
                      ),
                      _actionTile(
                        icon: Icons.upload_file,
                        label: 'Upload Image',
                        onTap: () {
                          controller.setVisionImage(
                            'assets/images/sample_card.png',
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 18.h),

                  Text(
                    'Define Success',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C).withOpacity(0.35),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Icon(
                                controller.goalSuccessCriteria.value
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: controller.goalSuccessCriteria.value
                                    ? const Color(0xFFDEB988)
                                    : Colors.white54,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: controller.goalController,
                                maxLines: 2,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'I will succeed if...',
                                  hintStyle: TextStyle(color: Colors.white24),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: controller.goalController,
                              builder: (context, value, child) {
                                return Text(
                                  '${value.text.length} / 159',
                                  style: TextStyle(color: Colors.white38),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 18.h),
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.saveVisionBoard();
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
                            'SAVE BOARD',
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

  Widget _actionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.white24),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 20.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14.sp),
          ],
        ),
      ),
    );
  }
}
