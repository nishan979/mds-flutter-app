import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
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
    final previewLocale = _selectedValue != null
        ? Locale(_selectedValue!)
        : null;
    final buttonLabel = previewLocale == null
        ? 'continue'.tr()
        : 'continue'.tr();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: SizedBox.expand(
              child: Image.asset(
                'assets/images/background_image.png',
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: AppColors.backgroundDark);
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Container(color: Color(0xFF02060e).withAlpha(150)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/header_image2.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(height: 240.h);
                    },
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 22.h,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF02060e).withAlpha(18),
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: Colors.white.withAlpha(38)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(89),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'select_language'.tr(),
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textWhite,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'choose_language'.tr(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textWhite.withAlpha(204),
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(20),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white.withAlpha(51),
                            ),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            dropdownColor: AppColors.backgroundDark,
                            underline: const SizedBox(),
                            value: _selectedValue,
                            hint: Row(
                              children: [
                                Text('🌍', style: TextStyle(fontSize: 24.sp)),
                                SizedBox(width: 12.w),
                                Text(
                                  'select_a_language'.tr(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.textWhite.withAlpha(179),
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
                                          style: TextStyle(fontSize: 24.sp),
                                        ),
                                        SizedBox(width: 12.w),
                                        Text(
                                          language['name']!,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppColors.textWhite,
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
                              color: AppColors.textWhite,
                              size: 26.sp,
                            ),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: InkWell(
                            onTap: _controller.continueToHome,
                            borderRadius: BorderRadius.circular(12.r),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Image.asset(
                                        'assets/images/login_button_bg.png',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      AppColors.secondary,
                                                      AppColors
                                                          .secondaryVariant,
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        color: Colors.black.withAlpha(25),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      buttonLabel,
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
