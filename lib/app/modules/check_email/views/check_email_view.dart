import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import '../../../core/theme/app_colors.dart';
import '../controllers/check_email_controller.dart';

class CheckEmailView extends StatelessWidget {
  final String email;
  const CheckEmailView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckEmailController(email: email));
    return Scaffold(
      appBar: AppBar(title: Text('check_email'.tr())),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            Icon(Icons.email, size: 110.h, color: AppColors.secondary),
            SizedBox(height: 20.h),
            Text(
              'check_your_email'.tr(),
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Text(
              'we_sent_verification'.tr(args: [email]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.resendVerification,
                child: controller.isLoading.value
                    ? SizedBox(
                        height: 18.h,
                        width: 18.h,
                        child: CircularProgressIndicator(),
                      )
                    : Text('resend_verification'.tr()),
              ),
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () => Get.offAllNamed('/login'),
              child: Text('back_to_login'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
