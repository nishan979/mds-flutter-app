import 'package:get/get.dart';
import 'api_client.dart';
import 'api_models.dart';

// User model based on login response
class User {
  final int id;
  final String email;
  final String name;
  final String? countryId;
  final String? stateId;
  final String? cityId;
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
      'profile_photo_url': profilePhotoUrl,
    };
  }
}

// Login response model
class LoginResponse {
  final String token;
  final String tokenType;
  final User user;

  LoginResponse({
    required this.token,
    required this.tokenType,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'token_type': tokenType, 'user': user.toJson()};
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
      print('[LOGIN] Request body: ' + requestBody.toString());
      final response = await _apiClient.post<LoginResponse>(
        '/auth/login',
        body: requestBody,
        converter: (json) =>
            LoginResponse.fromJson(json as Map<String, dynamic>),
      );
      print('[LOGIN] Response: ' + response.toString());
      if (response.success && response.data != null) {
        // Store token for future requests
        _apiClient.setAuthToken(response.data!.token);
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
        converter: (json) => null,
      );
      _apiClient.clearAuthToken();
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

  // Register
  Future<LoginResponse> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _apiClient.post<LoginResponse>(
        '/auth/register',
        body: {'email': email, 'password': password, 'name': name},
        converter: (json) =>
            LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        _apiClient.setAuthToken(response.data!.token);
        return response.data!;
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
}
