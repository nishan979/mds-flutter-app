import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/daily_challenge_controller.dart';
import '../views/start_challenge_view.dart';

class TodaysChallengeCard extends GetView<DailyChallengeController> {
  const TodaysChallengeCard({super.key});

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.amber;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'digital_hygiene':
        return Icons.phonelink_off;
      case 'time_management':
        return Icons.schedule;
      case 'detox':
        return Icons.spa;
      case 'social':
        return Icons.people;
      case 'discipline':
        return Icons.fitness_center;
      case 'mindfulness':
        return Icons.self_improvement;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final challenge = controller.todaysChallenge;
      if (challenge.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      final mainChallenge = challenge['main_challenge'] ?? {};
      final checkIn = challenge['check_in'] ?? {};
      final isCompleted = controller.isTodayChallengeCompleted();

      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C).withOpacity(0.8),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isCompleted
                ? Colors.green.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with month theme
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge['month_theme'] ?? 'Month Theme',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Day ${challenge['day']} of Year',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isCompleted)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 14.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Check-in section
            _buildTaskSection(
              icon: Icons.check_circle,
              iconColor: Colors.blue,
              title: 'Check-In',
              challenge: checkIn,
            ),

            SizedBox(height: 16.h),

            // Main challenge section
            _buildTaskSection(
              icon: Icons.flag,
              iconColor: Colors.orange,
              title: 'Main Challenge',
              challenge: mainChallenge,
            ),

            SizedBox(height: 16.h),

            // Points Summary
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Points Breakdown',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Check-In',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.sp,
                        ),
                      ),
                      Text(
                        '+${checkIn['points'] ?? 0} pts',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Main Challenge',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.sp,
                        ),
                      ),
                      Text(
                        '+${mainChallenge['points'] ?? 0} pts',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.amber.withOpacity(0.2), height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '+${((checkIn['points'] as int?) ?? 0) + ((mainChallenge['points'] as int?) ?? 0)} pts',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(
                      challenge['difficulty'] ?? '',
                    ).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: _getDifficultyColor(challenge['difficulty'] ?? ''),
                    ),
                  ),
                  child: Text(
                    'Difficulty: ${(challenge['difficulty'] ?? 'N/A').toUpperCase()}',
                    style: TextStyle(
                      color: _getDifficultyColor(challenge['difficulty'] ?? ''),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: Colors.purple.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(challenge['category'] ?? ''),
                        color: Colors.purple,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        (challenge['category'] ?? 'N/A')
                            .replaceAll('_', ' ')
                            .toUpperCase(),
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Start button
            if (!isCompleted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const StartChallengeView()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'START CHALLENGE',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildTaskSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Map challenge,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 18.sp),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          challenge['title'] ?? 'No title',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          challenge['description'] ?? 'No description',
          style: TextStyle(color: Colors.white70, fontSize: 12.sp, height: 1.4),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(Icons.schedule, color: Colors.blue, size: 14.sp),
            SizedBox(width: 4.w),
            Text(
              '${challenge['estimated_time_min'] ?? 0} min',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 12.w),
            Icon(Icons.star, color: Colors.amber, size: 14.sp),
            SizedBox(width: 4.w),
            Text(
              '${challenge['points'] ?? 0} points',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (challenge['verification_method'] != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Row(
              children: [
                Icon(Icons.verified, color: Colors.green, size: 14.sp),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    'Verification: ${challenge['verification_method']}',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 10.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
