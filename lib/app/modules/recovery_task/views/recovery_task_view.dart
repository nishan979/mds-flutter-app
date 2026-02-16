import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../controllers/recovery_task_controller.dart';

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
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10.h),
          // Date Selector
          _buildDateSelector(),

          SizedBox(height: 20.h),

          // Title Section
          Text(
            "Today’s Recovery Session",
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
            "Bounce Back & Regain Focus",
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
                _buildOverviewStepsCard(),
                SizedBox(height: 16.h),
                _buildOverviewReflectionCard(),
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

  Widget _buildOverviewStepsCard() {
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
                        color: Colors
                            .transparent, // Preview mode, unchecked or static
                      ),
                      child: SizedBox(width: 14.sp, height: 14.sp),
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
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: controller.startRecovery,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E60C9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                elevation: 4,
                shadowColor: Color(0xFF1E60C9).withOpacity(0.4),
              ),
              child: Text(
                "Complete Recovery (7 minutes)",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewReflectionCard() {
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
            "What did you learn from today's slip?",
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
        Obx(
          () => controller.currentStep.value < 4
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

  // STEP 3: Run the Recovery Protocol
  Widget _buildRecoveryProtocol() {
    return Column(
      children: [
        Text(
          "Run the Recovery Protocol",
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
              // 1. DND
              _buildProtocolItem(
                isCompleted: controller.dndActivated.value,
                title: "Put Your Phone on Do Not Disturb",
                subtitle: "Finish restart & stress DND.",
                trailing: ElevatedButton(
                  onPressed: controller.toggleDND,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.dndActivated.value
                        ? Colors.grey
                        : Color(0xFF1E60C9),
                    minimumSize: Size(100.w, 36.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  child: Text(
                    controller.dndActivated.value ? "Active" : "Activate DND",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: controller.dndActivated.value
                          ? Colors.white
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              Divider(),

              // 2. Breathing
              _buildProtocolItem(
                isCompleted: controller.breathingCompleted.value,
                title: "Take 10 Slow Breaths",
                subtitle: "Relax for a minute.",
                trailing: GestureDetector(
                  onTap: controller.startBreathing,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.breathingTimerString,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            color: Color(0xFF2E2E6A),
                          ),
                        ),
                        Text(
                          controller.isBreathing.value
                              ? "Breathing..."
                              : "Start",
                          style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(),

              // 3. Sentence
              _buildProtocolItem(
                isCompleted: controller.sentenceController.text.isNotEmpty,
                title: "Write 1 Sentence: \"I slipped because...\"",
                subtitle: "I slipped because...",
                customBody: TextField(
                  controller: controller.sentenceController,
                  decoration: InputDecoration(
                    hintText: "Type reason here...",
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 13.sp),
                  onChanged: (val) {
                    // trigger rebuild if needed or just let state be
                    controller.sentenceController.text = val;
                    // Hack to force UI update for checkbox if we were strictly observing
                  },
                ),
              ),
              Divider(),

              // 4. Repair Action
              _buildProtocolItem(
                isCompleted: controller.selectedRepairAction.isNotEmpty,
                title: "Pick One Repair Action",
                subtitle: null,
                customBody: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: controller.repairActions.map((action) {
                    final isSelected =
                        controller.selectedRepairAction.value == action;
                    return ChoiceChip(
                      label: Text(
                        action,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) =>
                          controller.selectRepairAction(action),
                      selectedColor: Color(0xFF1E60C9),
                      backgroundColor: Colors.grey.shade200,
                    );
                  }).toList(),
                ),
              ),
              Divider(),

              // 5. Focus Preset
              _buildProtocolItem(
                isCompleted: controller.focusPresetActivated.value,
                title: "Activate a Focus Preset (20 mins)",
                subtitle: null,
                trailing: ElevatedButton(
                  onPressed: controller.selectFocusPreset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E60C9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  child: Text(
                    "Select Focus Preset",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: controller.focusPresetActivated.value
                          ? Colors.white
                          : Colors.white,
                    ),
                  ),
                ),
              ),

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
        SizedBox(height: 20.h),
        _buildReflectionCard(readOnly: true),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4.h),
            height: 18.w,
            width: 18.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted ? Color(0xFF2E7BE2) : Colors.grey.shade400,
                width: 2,
              ),
              color: isCompleted ? Color(0xFF2E7BE2) : Colors.white,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                            ),
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (trailing != null) trailing,
                  ],
                ),
                if (customBody != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: customBody,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2.h),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4.r),
          ),
          padding: EdgeInsets.all(2),
          child: Icon(Icons.check, color: Colors.white, size: 12.sp),
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
            readOnly
                ? controller.sentenceController.text
                : "What did you learn from today's slip?",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13.sp),
          ),
          if (!readOnly) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: controller.reflectionController,
                maxLines: 3,
                style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type your thoughts...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreBoostPill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_upward, color: Colors.green, size: 16.sp),
          SizedBox(width: 4.w),
          Text(
            "+2 Points to Anti-SMUB",
            style: TextStyle(
              color: Color(0xFF2E2E6A),
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
