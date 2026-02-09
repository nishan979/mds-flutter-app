import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late final GetStorage _box;

  static const _keyAuthToken = 'auth_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyTokenExpiry = 'token_expiry'; // epoch millis
  static const _keyUser = 'user';

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  String? get token => _box.read<String?>(_keyAuthToken);
  Future<void> setToken(String token) async => _box.write(_keyAuthToken, token);
  Future<void> removeToken() async => _box.remove(_keyAuthToken);

  String? get refreshToken => _box.read<String?>(_keyRefreshToken);
  Future<void> setRefreshToken(String token) async =>
      _box.write(_keyRefreshToken, token);
  Future<void> removeRefreshToken() async => _box.remove(_keyRefreshToken);

  int? get tokenExpiryMillis => _box.read<int?>(_keyTokenExpiry);
  Future<void> setTokenExpiryMillis(int epochMillis) async =>
      _box.write(_keyTokenExpiry, epochMillis);
  Future<void> removeTokenExpiry() async => _box.remove(_keyTokenExpiry);

  Map<String, dynamic>? get user => _box.read<Map<String, dynamic>?>(_keyUser);
  Future<void> setUser(Map<String, dynamic> user) async =>
      _box.write(_keyUser, user);
  Future<void> removeUser() async => _box.remove(_keyUser);

  Future<void> clearAll() async => _box.erase();

  // Generic helpers for app settings
  Future<void> writeString(String key, String value) async =>
      _box.write(key, value);
  String? readString(String key) => _box.read<String?>(key);

  Future<void> writeStringList(String key, List<String> values) async =>
      _box.write(key, values);
  List<String>? readStringList(String key) =>
      _box.read<List<dynamic>?>(key)?.cast<String>();

  Future<void> writeInt(String key, int value) async => _box.write(key, value);
  int? readInt(String key) => _box.read<int?>(key);
}
