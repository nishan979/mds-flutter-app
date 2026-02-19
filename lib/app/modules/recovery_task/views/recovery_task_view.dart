import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../controllers/recovery_task_controller.dart';
import '../data/recovery_templates.dart'; // Import for Enums

class RecoveryTaskView extends GetView<RecoveryTaskController> {
  const RecoveryTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Obx(
          () => IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
            onPressed: controller.currentStep.value == 0
                ? Get.back
                : controller.previousStep,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Recovery Task",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E7BE2), Color(0xFF86B9FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.currentStep.value == 0) {
              return _buildOverviewPage();
            } else {
              return _buildWizardPage();
            }
          }),
        ),
      ),
    );
  }

  // --- Overview Page (Step 0) ---
  Widget _buildOverviewPage() {
    // Ensure template is loaded
    final template = controller.dailyTemplate.value;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10.h),
          // Date Selector
          _buildDateSelector(),

          SizedBox(height: 20.h),

          // Title Section
          Text(
            template.title, // Dynamic Title
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            template.description, // Dynamic Description
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              "Reflect and reset after slipping off track. Let's get you back on course.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12.sp,
                height: 1.4,
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // Card Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                _buildOverviewStepsCard(template),
                SizedBox(height: 16.h),
                _buildOverviewReflectionCard(template),
                SizedBox(height: 20.h),
                _buildScoreBoostPill(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStepsCard(RecoveryTaskTemplate template) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Recovery Steps:",
            style: TextStyle(
              color: Color(0xFF2E2E6A),
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),
          Obx(
            () => ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.overviewSteps.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 24.h, color: Colors.grey.withOpacity(0.2)),
              itemBuilder: (context, index) {
                final step = controller.overviewSteps[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 2.h),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 2,
                        ),
                        // Visual check if toggled in overview (optional interactivity)
                        color: step.isCompleted
                            ? Color(0xFF2E7BE2)
                            : Colors.transparent,
                      ),
                      child: SizedBox(
                        width: 14.sp,
                        height: 14.sp,
                        child: step.isCompleted
                            ? Icon(
                                Icons.check,
                                size: 10.sp,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: TextStyle(
                              color: Color(0xFF2E2E6A),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            step.subtitle,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 24.h),
          Obx(() {
            final isCompleted = controller.isDailyCompleted.value;
            return SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: isCompleted ? null : controller.startRecovery,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted
                      ? Colors.green
                      : Color(0xFF1E60C9),
                  disabledBackgroundColor: Colors.green.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  elevation: 4,
                  shadowColor: (isCompleted ? Colors.green : Color(0xFF1E60C9))
                      .withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isCompleted) ...[
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      isCompleted
                          ? "Recovery Completed"
                          : "Complete Recovery (${template.estimatedMinutes} minutes)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOverviewReflectionCard(RecoveryTaskTemplate template) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today’s Reflection:",
            style: TextStyle(
              color: Color(0xFF2E2E6A),
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Divider(color: Colors.grey.withOpacity(0.2)),
          SizedBox(height: 8.h),
          Text(
            template.reflectionPrompt, // Dynamic Prompt
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13.sp),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              "Type your thoughts...",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: controller.previousDay,
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white70,
              size: 14.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Obx(
            () => Text(
              DateFormat('MMMM d').format(controller.selectedDate.value),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: controller.nextDay,
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  // --- Wizard Pages (Steps 1-4) ---

  Widget _buildWizardPage() {
    return Column(
      children: [
        SizedBox(height: 10.h),

        // Step Indicator
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              "< Step ${controller.currentStep.value} of ${controller.totalSteps} >",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        SizedBox(height: 20.h),

        // Dynamic Body Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Obx(() {
              switch (controller.currentStep.value) {
                case 1:
                  return _buildIdentifySlip();
                case 2:
                  return _buildChooseTrigger();
                case 3:
                  return _buildRecoveryProtocol();
                case 4:
                  return _buildRecoveryComplete();
                default:
                  return Container();
              }
            }),
          ),
        ),

        // Footer: Reflection (Visible on steps 1, 2, 3)
        // Note: For Step 3, reflection might be part of the dynamic steps, so maybe hide footer there?
        // The original design had a persistent footer. Let's keep it for Step 1 & 2, but
        // if Step 3 has a text input, having another input at the bottom is confusing.
        // Let's hide it for step 3 if the template has text inputs.
        Obx(
          () => controller.currentStep.value < 3
              ? Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                  child: _buildReflectionCard(),
                )
              : SizedBox(),
        ),
      ],
    );
  }

  // STEP 1: Identify the Slip
  Widget _buildIdentifySlip() {
    return Column(
      children: [
        Text(
          "Identify the Slip",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          "What happened? Select the slip that brought you here.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 24.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              ...controller.slips.map(
                (slip) => _buildRadioOption(
                  title: slip,
                  groupValue: controller.selectedSlip.value,
                  onChanged: (val) => controller.selectedSlip.value = val!,
                ),
              ),
              SizedBox(height: 20.h),
              _buildContinueButton(onPressed: controller.nextStep),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 2: Choose the Trigger
  Widget _buildChooseTrigger() {
    return Column(
      children: [
        Text(
          "Choose the Trigger",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          "What was the main driver behind the slip?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 24.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              ...controller.triggers.map(
                (trigger) => _buildRadioOption(
                  title: trigger,
                  groupValue: controller.selectedTrigger.value,
                  onChanged: (val) => controller.selectedTrigger.value = val!,
                ),
              ),
              SizedBox(height: 20.h),
              _buildContinueButton(onPressed: controller.nextStep),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 3: Run the Recovery Protocol (Dynamic)
  Widget _buildRecoveryProtocol() {
    final template = controller.dailyTemplate.value;

    return Column(
      children: [
        Text(
          template.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          "Follow these steps to reset and refocus.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 24.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dynamic List of Steps
              ...template.steps.map((step) {
                return Column(
                  children: [
                    _buildDynamicStep(step),
                    Divider(height: 24.h),
                  ],
                );
              }),

              SizedBox(height: 24.h),
              _buildContinueButton(
                onPressed: controller.nextStep,
                label: "Complete Recovery",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicStep(RecoveryStepData step) {
    switch (step.type) {
      case RecoveryStepType.toggle:
      case RecoveryStepType.checkbox:
        return Obx(() {
          final isChecked = controller.stepStates[step.id] == true;
          return _buildProtocolItem(
            isCompleted: isChecked,
            title: step.title,
            subtitle: step.subtitle,
            trailing: Checkbox(
              value: isChecked,
              activeColor: Color(0xFF1E60C9),
              onChanged: (val) => controller.toggleStep(step.id),
            ),
          );
        });

      case RecoveryStepType.timer:
        return Obx(() {
          final isPlaying = controller.isTimerPlaying(step.id);
          final seconds = controller.stepStates[step.id] as int? ?? 0;
          return _buildProtocolItem(
            isCompleted: seconds == 0,
            title: step.title,
            subtitle: step.subtitle,
            trailing: GestureDetector(
              onTap: () => controller.toggleTimer(step.id),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isPlaying ? Color(0xFFE3F2FD) : Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.getTimerString(step.id),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Color(0xFF2E2E6A),
                      ),
                    ),
                    Text(
                      isPlaying ? "Pause" : "Start",
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        });

      case RecoveryStepType.textInput:
        return _buildProtocolItem(
          isCompleted: true, // Always show as available
          title: step.title,
          subtitle: step.subtitle,
          customBody: TextField(
            controller: controller.getTextController(step.id),
            decoration: InputDecoration(
              hintText: "Type response here...",
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            maxLines: null,
            style: TextStyle(fontSize: 13.sp),
          ),
        );

      case RecoveryStepType.choice:
        return Obx(() {
          final isSelected = controller.stepStates[step.id] != "";
          final List<String> options = step.content as List<String>;

          return _buildProtocolItem(
            isCompleted: isSelected,
            title: step.title,
            subtitle: step.subtitle,
            customBody: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: options.map((opt) {
                final active = controller.stepStates[step.id] == opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: active,
                  onSelected: (val) => controller.updateChoice(step.id, opt),
                  selectedColor: Color(0xFF1E60C9),
                  labelStyle: TextStyle(
                    color: active ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
          );
        });
    }
  }

  // STEP 4: Recovery Complete
  Widget _buildRecoveryComplete() {
    return Column(
      children: [
        SizedBox(height: 40.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              Icon(Icons.celebration, size: 60.sp, color: Colors.orange),
              SizedBox(height: 16.h),
              Text(
                "Recovery Complete!",
                style: TextStyle(
                  color: Color(0xFF2E2E6A),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Great job! You've turned the slip into a learning moment.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp),
              ),
              SizedBox(height: 30.h),

              _buildCheckItem("Recovery Task Completed", "Logged successfully"),
              SizedBox(height: 16.h),
              _buildCheckItem(
                "+2 Points to Anti-SMUB Score",
                "Your score improved",
              ),
              SizedBox(height: 16.h),
              _buildCheckItem(
                "Earned 1 Recovery Credit",
                "This credit can help reduce a future penalty",
              ),

              SizedBox(height: 30.h),
              _buildContinueButton(
                onPressed: controller.finishRecovery,
                label: "Finish",
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        _buildScoreBoostPill(),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _buildRadioOption({
    required String title,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
    final isSelected = groupValue == title;
    return GestureDetector(
      onTap: () => onChanged(title),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFEDF4FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: isSelected
              ? Border.all(color: Color(0xFF2E7BE2))
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Container(
              height: 20.w,
              width: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: isSelected ? Color(0xFF2E7BE2) : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? Color(0xFF2E7BE2) : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolItem({
    required bool isCompleted,
    required String title,
    String? subtitle,
    Widget? trailing,
    Widget? customBody,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 4.h),
                height: 18.w,
                width: 18.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? Color(0xFF1E60C9) : Colors.transparent,
                  border: Border.all(
                    color: isCompleted
                        ? Color(0xFF1E60C9)
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? Icon(Icons.check, size: 12.sp, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E2E6A),
                        decoration:
                            isCompleted &&
                                trailing == null &&
                                customBody ==
                                    null // Strike through only if it's a simple checkbox
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          if (customBody != null) ...[
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.only(left: 30.w),
              child: customBody,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckItem(String title, String subtitle) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 24.sp),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E2E6A),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton({
    required VoidCallback onPressed,
    String label = "Continue",
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1E60C9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          elevation: 4,
          shadowColor: Color(0xFF1E60C9).withOpacity(0.4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildReflectionCard({bool readOnly = false}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, color: Colors.orange, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                "Quick Reflection",
                style: TextStyle(
                  color: Color(0xFF2E2E6A),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: controller.reflectionController,
            enabled: !readOnly,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "How are you feeling right now?",
              filled: true,
              fillColor: Color(0xFFF0F4F8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(12.w),
            ),
            style: TextStyle(fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBoostPill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Color(0xFF00C853).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Color(0xFF00C853).withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt, color: Color(0xFF2E7D32), size: 16.sp),
          SizedBox(width: 6.w),
          Text(
            "Complete now to restore score",
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
