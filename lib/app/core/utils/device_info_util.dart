import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtil {
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return {
        'platform': 'android',
        'model': androidInfo.model,
        'manufacturer': androidInfo.manufacturer,
        'version': androidInfo.version.release,
        'sdkInt': androidInfo.version.sdkInt,
        'device': androidInfo.device,
        'id': androidInfo.id,
        'brand': androidInfo.brand,
      };
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return {
        'platform': 'ios',
        'model': iosInfo.utsname.machine,
        'systemName': iosInfo.systemName,
        'systemVersion': iosInfo.systemVersion,
        'name': iosInfo.name,
        'identifierForVendor': iosInfo.identifierForVendor,
      };
    } else {
      return {'platform': Platform.operatingSystem};
    }
  }
}
