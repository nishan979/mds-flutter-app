import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../services/challenge_service.dart';
import '../controllers/daily_challenge_controller.dart';
import 'start_challenge_view.dart';

class ChallengeMonthsView extends GetView<DailyChallengeController> {
  const ChallengeMonthsView({super.key});

  @override
  Widget build(BuildContext context) {
    final challengeService = ChallengeService();
    final months = const [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '365 Day Challenges',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
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
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.22)),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Browse challenges across all 365 days and all months.',
                    style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                  ),
                  SizedBox(height: 18.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      final month = index + 1;
                      final monthName = months[index];
                      final challenges = challengeService.getChallengesByMonth(
                        month,
                      );

                      return _MonthCard(
                        month: month,
                        monthName: monthName,
                        challengeCount: challenges.length,
                        onTap: () {
                          Get.dialog(
                            _MonthDetailsDialog(
                              monthName: monthName,
                              challenges: challenges,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthCard extends StatelessWidget {
  final int month;
  final String monthName;
  final int challengeCount;
  final VoidCallback onTap;

  const _MonthCard({
    required this.month,
    required this.monthName,
    required this.challengeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = const [
      0xFF6A5ACD,
      0xFF4169E1,
      0xFF20B2AA,
      0xFF32CD32,
      0xFFDAA520,
      0xFFFF8C00,
      0xFFFF6347,
      0xFF8B008B,
      0xFF00CED1,
      0xFF9932CC,
      0xFFFFD700,
      0xFF4B0082,
    ];

    final accent = Color(colors[month - 1]);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [accent.withOpacity(0.3), accent.withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: accent.withOpacity(0.5), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                monthName.substring(0, 3),
                style: TextStyle(color: Colors.white70, fontSize: 11.sp),
              ),
              Text(
                '$month',
                style: TextStyle(
                  color: accent,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$challengeCount days',
                style: TextStyle(color: Colors.white54, fontSize: 10.sp),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 10.sp),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthDetailsDialog extends StatefulWidget {
  final String monthName;
  final List challenges;

  const _MonthDetailsDialog({
    required this.monthName,
    required this.challenges,
  });

  @override
  State<_MonthDetailsDialog> createState() => _MonthDetailsDialogState();
}

class _MonthDetailsDialogState extends State<_MonthDetailsDialog> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.monthName} (${widget.challenges.length} challenges)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white12),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  itemCount: widget.challenges.length,
                  itemBuilder: (context, index) {
                    final challenge = widget.challenges[index];
                    final mapped = ChallengeService.dayOfYearToMonthDay(
                      challenge.day,
                    );
                    final dayOfMonth = mapped['day'] ?? challenge.day;

                    return GestureDetector(
                      onTap: () {
                        Get.back();
                        Get.to(() => const StartChallengeView());
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Day $dayOfMonth',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _difficultyColor(
                                      challenge.difficulty,
                                    ).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    challenge.difficulty.toUpperCase(),
                                    style: TextStyle(
                                      color: _difficultyColor(
                                        challenge.difficulty,
                                      ),
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              challenge.mainChallenge.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Wrap(
                              spacing: 12.w,
                              runSpacing: 6.h,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.category,
                                      size: 12.sp,
                                      color: Colors.white54,
                                    ),
                                    SizedBox(width: 4.w),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 90.w,
                                      ),
                                      child: Text(
                                        challenge.category,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 12.sp,
                                      color: Colors.white54,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${challenge.mainChallenge.estimatedTimeMin} min',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 12.sp,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${challenge.mainChallenge.points} pts',
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
