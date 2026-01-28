import 'dart:async';

import 'package:get/get.dart';
import '../storage/storage_service.dart';
import 'api_client.dart';
import 'api_models.dart';
import 'api_constants.dart';
import '../../widgets/app_snackbar.dart';
import '../../routes/app_pages.dart';

// User model based on login response
class User {
  final int id;
  final String email;
  final String name;
  final String? countryId;
  final String? stateId;
  final String? cityId;
  final String? emailVerifiedAt;
  final String? twoFactorConfirmedAt;
  final bool? isMinimalist;
  final String? currentTeamId;
  final String? profilePhotoPath;
  final String createdAt;
  final String updatedAt;
  final String? phone;
  final String? ageRange;
  final String? gender;
  final List<dynamic>? purpose;
  final String? purposeNotes;
  final bool? updatesOptIn;
  final List<dynamic>? headFrom;
  final String? unsubscribeToken;
  final String? unsubscribedAt;
  final String profilePhotoUrl;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.countryId,
    this.stateId,
    this.cityId,
    this.emailVerifiedAt,
    this.twoFactorConfirmedAt,
    this.isMinimalist,
    this.currentTeamId,
    this.profilePhotoPath,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.ageRange,
    this.gender,
    this.purpose,
    this.purposeNotes,
    this.updatesOptIn,
    this.headFrom,
    this.unsubscribeToken,
    this.unsubscribedAt,
    required this.profilePhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      countryId: json['country_id'] as String?,
      stateId: json['state_id'] as String?,
      cityId: json['city_id'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      twoFactorConfirmedAt: json['two_factor_confirmed_at'] as String?,
      isMinimalist: json['is_minimalist'] as bool?,
      currentTeamId: json['current_team_id'] as String?,
      profilePhotoPath: json['profile_photo_path'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      phone: json['phone'] as String?,
      ageRange: json['age_range'] as String?,
      gender: json['gender'] as String?,
      purpose: json['purpose'] as List<dynamic>?,
      purposeNotes: json['purpose_notes'] as String?,
      updatesOptIn: json['updates_opt_in'] as bool?,
      headFrom: json['head_from'] as List<dynamic>?,
      unsubscribeToken: json['unsubscribe_token'] as String?,
      unsubscribedAt: json['unsubscribed_at'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'country_id': countryId,
      'state_id': stateId,
      'city_id': cityId,
      'is_minimalist': isMinimalist,
      'current_team_id': currentTeamId,
      'profile_photo_path': profilePhotoPath,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'phone': phone,
      'age_range': ageRange,
      'gender': gender,
      'purpose': purpose,
      'purpose_notes': purposeNotes,
      'updates_opt_in': updatesOptIn,
      'head_from': headFrom,
      'unsubscribe_token': unsubscribeToken,
      'unsubscribed_at': unsubscribedAt,
      'email_verified_at': emailVerifiedAt,
      'two_factor_confirmed_at': twoFactorConfirmedAt,
      'profile_photo_url': profilePhotoUrl,
    };
  }
}

// Login response model
class LoginResponse {
  final String token;
  final String tokenType;
  final User user;
  final String? refreshToken;
  final String? expiresAt;

  LoginResponse({
    required this.token,
    required this.tokenType,
    required this.user,
    this.refreshToken,
    this.expiresAt,
  });

  @override
  String toString() {
    return 'LoginResponse(token: $token, tokenType: $tokenType, user: ${user.email})';
  }

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      refreshToken: json['refresh_token'] as String?,
      expiresAt: json['expires_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'token_type': tokenType,
      'user': user.toJson(),
      'refresh_token': refreshToken,
      'expires_at': expiresAt,
    };
  }
}

class AuthService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  AuthService() {
    // Ensure ApiClient is initialized
  }

  // Login
  Future<LoginResponse> login({
    required String email,
    required String password,
    required String deviceName,
  }) async {
    try {
      final requestBody = {
        'email': email,
        'password': password,
        'device_name': deviceName,
      };
      print('[LOGIN] Request body: $requestBody');
      final response = await _apiClient.post<LoginResponse>(
        '/auth/login',
        body: requestBody,
        converter: (json) =>
            LoginResponse.fromJson(json as Map<String, dynamic>),
      );
      print('[LOGIN] Response: $response');
      if (response.success && response.data != null) {
        // Store token for future requests
        _apiClient.setAuthToken(response.data!.token);
        // Save token and user to persistent storage
        final storage = Get.find<StorageService>();
        await storage.setToken(response.data!.token);
        // save refresh token and expiry if provided by backend (defensively)
        String? refresh;
        String? expiresAt;
        try {
          refresh = response.data!.refreshToken;
          expiresAt = response.data!.expiresAt;
        } catch (_) {
          // fallback if data is a map
          try {
            final dyn = response.data as dynamic;
            refresh = dyn['refresh_token'] as String?;
            expiresAt = dyn['expires_at'] as String?;
          } catch (_) {
            refresh = null;
            expiresAt = null;
          }
        }

        if (refresh != null) {
          await storage.setRefreshToken(refresh);
        }
        if (expiresAt != null) {
          try {
            final dt = DateTime.parse(expiresAt);
            await storage.setTokenExpiryMillis(dt.millisecondsSinceEpoch);
          } catch (_) {}
        }

        // store user
        try {
          await storage.setUser(response.data!.user.toJson());
        } catch (_) {
          // if data isn't typed, try map access
          try {
            final dyn = response.data as dynamic;
            if (dyn['user'] != null) {
              await storage.setUser(dyn['user'] as Map<String, dynamic>);
            }
          } catch (_) {}
        }
        // schedule auto logout/expiry handling
        scheduleAutoLogout();
        return response.data!;
      } else {
        throw ApiException(
          message: response.message ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('[LOGIN] Error: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiClient.post<void>(
        '/auth/logout',
        body: {},
        converter: (json) {},
      );
      _apiClient.clearAuthToken();
      final storage = Get.find<StorageService>();
      await storage.removeToken();
      await storage.removeUser();
    } catch (e) {
      rethrow;
    }
  }

  // Forgot password
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/forgot-password',
        body: {'email': email},
        converter: (json) => json as Map<String, dynamic>,
      );

      if (response.success) {
        return response.data ?? {'message': response.message ?? 'Success'};
      } else {
        throw ApiException(
          message: response.message ?? 'Failed to send reset link',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Resend verification
  Future<Map<String, dynamic>> resendVerification({
    required String email,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/resend-verification',
        body: {'email': email},
        converter: (json) => json as Map<String, dynamic>,
      );

      if (response.success) {
        return response.data ??
            {'message': response.message ?? 'Verification sent'};
      } else {
        throw ApiException(
          message: response.message ?? 'Failed to resend verification',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
        converter: (json) => json as Map<String, dynamic>,
      );

      if (response.success) {
        return response.data ??
            {'message': response.message ?? 'Registration successful'};
      } else {
        throw ApiException(
          message: response.message ?? 'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get auth client
  ApiClient get apiClient => _apiClient;

  // Token expiry / auto logout
  Timer? _expiryTimer;

  void scheduleAutoLogout() {
    try {
      final storage = Get.find<StorageService>();
      final expiry = storage.tokenExpiryMillis;
      _expiryTimer?.cancel();
      if (expiry != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final diff = expiry - now;
        if (diff > 0) {
          _expiryTimer = Timer(Duration(milliseconds: diff), () {
            // expire
            logout();
            Get.offAllNamed(Routes.LOGIN);
            showAppSnack(
              title: 'Session expired',
              message: 'Please login again',
              type: SnackType.info,
            );
          });
        }
      }
    } catch (e) {
      // ignore
    }
  }

  Future<bool> refreshToken() async {
    try {
      final storage = Get.find<StorageService>();
      final refresh = storage.refreshToken;
      if (refresh == null) return false;

      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.refreshTokenEndpoint,
        body: {'refresh_token': refresh},
        converter: (json) => json as Map<String, dynamic>,
      );

      if (response.success &&
          response.data != null &&
          response.data!['token'] != null) {
        final newToken = response.data!['token'] as String;
        _apiClient.setAuthToken(newToken);
        await storage.setToken(newToken);
        if (response.data!['refresh_token'] != null) {
          await storage.setRefreshToken(
            response.data!['refresh_token'] as String,
          );
        }
        if (response.data!['expires_at'] != null) {
          try {
            final dt = DateTime.parse(response.data!['expires_at'] as String);
            await storage.setTokenExpiryMillis(dt.millisecondsSinceEpoch);
          } catch (_) {}
        }
        scheduleAutoLogout();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
