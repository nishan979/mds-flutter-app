import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/anti_smub_test_controller.dart';

class TakeAntiSmubTestView extends GetView<AntiSmubTestController> {
  const TakeAntiSmubTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e), // Consistent with app theme
      appBar: AppBar(
        title: Text(
          "Assessment in Progress",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Linear Progress Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          "Question ${controller.currentQuestionIndex.value + 1}/${controller.totalQuestions.value}",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          "${(controller.progress * 100).toInt()}%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 8.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Obx(() {
                      final progressValue = controller.progress.clamp(0.0, 1.0);
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: constraints.maxWidth * progressValue,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.r),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.redAccent,
                                      Colors.greenAccent,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Question Content
            Expanded(
              child: Obx(() {
                final question = controller.currentQuestion;
                if (question == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Check previously selected option
                final selectedOptionId =
                    controller.selectedOptions[question.id];

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      Text(
                        question.text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: question.options.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final option = question.options[index];
                          final isSelected = selectedOptionId == option.id;

                          return GestureDetector(
                            onTap: () => controller.selectOption(option.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFDEB988).withOpacity(0.2)
                                    : Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFDEB988)
                                      : Colors.white.withOpacity(0.1),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20.w,
                                    height: 20.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFDEB988)
                                            : Colors.white54,
                                        width: 2,
                                      ),
                                      color: isSelected
                                          ? const Color(0xFFDEB988)
                                          : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? Icon(
                                            Icons.check,
                                            size: 14.sp,
                                            color: Colors.black,
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Text(
                                      option.text,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white70,
                                        fontSize: 16.sp,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),

            // Navigation Buttons
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Obx(() {
                final index = controller.currentQuestionIndex.value;
                final total = controller.totalQuestions.value;
                final question = controller.currentQuestion;
                final isLast = index == total - 1;

                // Check if answered
                final hasAnswer =
                    question != null &&
                    controller.selectedOptions.containsKey(question.id);

                return Row(
                  children: [
                    // Prev Button
                    if (index > 0) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.previousQuestion,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            "Previous",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                    ],

                    // Next / Finish Button
                    Expanded(
                      flex: index > 0
                          ? 2
                          : 1, // Full width (flex1 is effectively full if alone) or 2/3 width
                      child: ElevatedButton(
                        onPressed: hasAnswer ? controller.nextQuestion : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDEB988),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          disabledBackgroundColor: Colors.white.withOpacity(
                            0.1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          isLast ? "Finish Test" : "Next Question",
                          style: TextStyle(
                            color: hasAnswer ? Colors.black : Colors.white38,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
