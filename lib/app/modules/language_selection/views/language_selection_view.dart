import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/language_selection_controller.dart';

class LanguageSelectionView extends StatefulWidget {
  const LanguageSelectionView({super.key});

  @override
  State<LanguageSelectionView> createState() => _LanguageSelectionViewState();
}

class _LanguageSelectionViewState extends State<LanguageSelectionView> {
  late LanguageSelectionController _controller;
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(LanguageSelectionController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Your Language',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Choose your preferred language to get started',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 60.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyLight, width: 2.w),
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColors.white,
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox(),
                  value: _selectedValue,
                  hint: Row(
                    children: [
                      Text('🌍', style: TextStyle(fontSize: 24.sp)),
                      SizedBox(width: 12.w),
                      Text(
                        'Select a language',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  items: _controller.languages
                      .map(
                        (language) => DropdownMenuItem<String>(
                          value: language['code']!,
                          child: Row(
                            children: [
                              Text(
                                language['flag']!,
                                style: TextStyle(fontSize: 28.sp),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                language['name']!,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedValue = value;
                      });
                      _controller.selectLanguage(value);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.primary,
                    size: 28.sp,
                  ),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textPrimary,
                  ),
                  dropdownColor: AppColors.white,
                ),
              ),
              SizedBox(height: 80.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _controller.continueToHome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
