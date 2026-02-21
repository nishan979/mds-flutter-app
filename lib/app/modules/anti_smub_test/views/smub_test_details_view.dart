import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/models/anti_smub_models.dart';
import '../controllers/anti_smub_test_controller.dart';

class SmubTestDetailsView extends GetView<AntiSmubTestController> {
  final SmubTest test;

  const SmubTestDetailsView({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    final policy = test.policy;
    final eligibility = test.eligibility;

    return Scaffold(
      backgroundColor: const Color(0xFF060B1A),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 100.w,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Row(
            children: [
              SizedBox(width: 16.w),
              Icon(Icons.arrow_back_ios, color: Colors.white70, size: 18.sp),
              Text(
                'Back',
                style: TextStyle(color: Colors.white70, fontSize: 16.sp),
              ),
            ],
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
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          test.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (test.version != null &&
                            test.version!.isNotEmpty) ...[
                          SizedBox(height: 6.h),
                          Text(
                            'Version: ${test.version}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                        SizedBox(height: 10.h),
                        Text(
                          test.description,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _SectionCard(
                          title: 'Policy',
                          rows: [
                            _buildRow('Type', policy?.type),
                            _buildRow(
                              'Questions',
                              policy?.questionCount != null
                                  ? '${policy!.questionCount}'
                                  : null,
                            ),
                            _buildRow(
                              'Duration',
                              policy?.durationMinutes != null
                                  ? '${policy!.durationMinutes} minutes'
                                  : null,
                            ),
                            _buildRow('Timed', _toYesNo(policy?.isTimed)),
                            _buildRow(
                              'Retake (Months)',
                              policy?.retakeMonths != null
                                  ? '${policy!.retakeMonths}'
                                  : null,
                            ),
                            _buildRow('Retake', _toYesNo(policy?.retakeOn)),
                            _buildRow(
                              'Result Locked',
                              _toYesNo(
                                policy?.resultsLocked ?? policy?.resultLocked,
                              ),
                            ),
                            _buildRow(
                              'Certificate Mode',
                              policy?.certMode ?? policy?.certModel,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _SectionCard(
                          title: 'Eligibility',
                          rows: [
                            _buildRow(
                              'Allowed',
                              _toYesNo(eligibility?.allowed),
                            ),
                            _buildRow('Eligible At', eligibility?.eligibleAt),
                            _buildRow('Reason', eligibility?.reason),
                            _buildRow('Reason Detail', eligibility?.reasonText),
                            _buildRow(
                              'Blocked Session',
                              eligibility?.blockedSessionId != null
                                  ? '${eligibility!.blockedSessionId}'
                                  : null,
                            ),
                            _buildRow('Action', eligibility?.action),
                          ],
                        ),
                        SizedBox(height: 28.h),
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: eligibility?.allowed == false
                                ? null
                                : () => controller.startTest(test),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E2E6A),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.r),
                              ),
                            ),
                            child: Text(
                              'START TEST',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _DetailRow? _buildRow(String label, String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return _DetailRow(label: label, value: value);
  }

  String? _toYesNo(bool? value) {
    if (value == null) return null;
    return value ? 'Yes' : 'No';
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<_DetailRow?> rows;

  const _SectionCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    final visibleRows = rows.whereType<_DetailRow>().toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withOpacity(0.7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          if (visibleRows.isEmpty)
            Text(
              'No data available',
              style: TextStyle(color: Colors.white54, fontSize: 13.sp),
            )
          else
            ...visibleRows.map(
              (row) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 130.w,
                      child: Text(
                        row.label,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row.value,
                        style: TextStyle(color: Colors.white, fontSize: 13.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailRow {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});
}
