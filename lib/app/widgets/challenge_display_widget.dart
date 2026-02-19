import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mds/app/data/models/daily_challenge_model.dart';
import 'package:mds/app/services/challenge_service.dart';

/// Example widget showing how to display challenges from ChallengeService
class ChallengeDisplayWidget extends StatelessWidget {
  final ChallengeService _challengeService = ChallengeService();

  ChallengeDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's Challenge
          Text(
            "Today's Challenge",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          _buildTodaysChallengeCard(),

          SizedBox(height: 24.h),

          // Current Month's Challenges
          Text(
            "This Month's Challenges",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          _buildMonthChallengesGrid(),
        ],
      ),
    );
  }

  Widget _buildTodaysChallengeCard() {
    final today = _challengeService.getTodayChallenge();

    if (today == null) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          'No challenge for today',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E2C).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with difficulty and category
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${today.month}/${today.day}',
                      style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                    ),
                    Text(
                      today.monthTheme,
                      style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(today.difficulty).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: _getDifficultyColor(today.difficulty),
                  ),
                ),
                child: Text(
                  today.difficulty.toUpperCase(),
                  style: TextStyle(
                    color: _getDifficultyColor(today.difficulty),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Check-in section
          Text(
            'Check-in: ${today.checkIn.title}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            today.checkIn.description,
            style: TextStyle(fontSize: 12.sp, color: Colors.white70),
          ),
          SizedBox(height: 8.h),
          Text(
            '${today.checkIn.estimatedTimeMin} min | ${today.checkIn.points} points',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.amber,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 16.h),

          // Main challenge section
          Text(
            'Challenge: ${today.mainChallenge.title}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            today.mainChallenge.description,
            style: TextStyle(fontSize: 12.sp, color: Colors.white70),
          ),
          SizedBox(height: 8.h),
          Text(
            '${today.mainChallenge.estimatedTimeMin} min | ${today.mainChallenge.points} points',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.amber,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (today.mainChallenge.verificationMethod != null)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                'Verification: ${today.mainChallenge.verificationMethod}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMonthChallengesGrid() {
    final now = DateTime.now();
    final monthChallenges = _challengeService.getChallengesByMonth(now.month);

    if (monthChallenges.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          'No challenges for this month',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 1.2,
      ),
      itemCount: monthChallenges.length,
      itemBuilder: (context, index) {
        final challenge = monthChallenges[index];
        return _buildChallengeCard(challenge);
      },
    );
  }

  Widget _buildChallengeCard(DailyChallenge challenge) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E2C).withOpacity(0.6),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${challenge.month}/${challenge.day}',
                style: TextStyle(fontSize: 10.sp, color: Colors.white54),
              ),
              SizedBox(height: 4.h),
              Text(
                challenge.mainChallenge.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(
                    challenge.difficulty,
                  ).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  challenge.difficulty.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: _getDifficultyColor(challenge.difficulty),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${challenge.checkIn.points + challenge.mainChallenge.points} pts',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
}
