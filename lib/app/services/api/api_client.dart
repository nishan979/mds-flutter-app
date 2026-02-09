import 'package:get/get.dart';
import 'dart:convert';
import 'api_constants.dart';
import 'api_models.dart';
import 'auth_service.dart';
import '../storage/storage_service.dart';

class ApiClient extends GetxService {
  late final GetConnect _getConnect;
  String? _authToken;

  ApiClient() {
    _initializeClient();
  }

  void _initializeClient() {
    _getConnect = GetConnect(
      timeout: const Duration(milliseconds: ApiConstants.connectTimeout),
    );

    _getConnect.httpClient.baseUrl = ApiConstants.baseUrl;

    // Add request interceptor
    _getConnect.httpClient.addRequestModifier<dynamic>((request) {
      request.headers.addAll(ApiConstants.defaultHeaders);
      if (_authToken != null) {
        request.headers['Authorization'] = 'Bearer $_authToken';
      }
      return request;
    });

    // Add response error interceptor
    _getConnect.httpClient.addResponseModifier<dynamic>((request, response) {
      return response;
    });
  }

  // Set auth token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Clear auth token
  void clearAuthToken() {
    _authToken = null;
  }

  // GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    required T Function(dynamic) converter,
    Map<String, String>? headers,
  }) async {
    try {
      final url = '${_getConnect.httpClient.baseUrl}$endpoint';
      print('[API][GET] URL: $url');
      final usedHeaders = headers ?? ApiConstants.defaultHeaders;
      print('[API][GET] Headers: $usedHeaders');

      var response = await _getConnect.get(endpoint, headers: usedHeaders);

      print('[API][GET] Status: ${response.statusCode}');
      print('[API][GET] Body: ${response.bodyString}');

      if (response.statusCode == 401) {
        print('[API][GET] Received 401, attempting token refresh');
        final auth = Get.find<AuthService>();
        final refreshed = await auth.refreshToken();
        if (refreshed) {
          print('[API][GET] Refresh succeeded, retrying request');
          usedHeaders['Authorization'] =
              'Bearer ${Get.find<StorageService>().token}';
          response = await _getConnect.get(endpoint, headers: usedHeaders);
          print('[API][GET] Retry Status: ${response.statusCode}');
          print('[API][GET] Retry Body: ${response.bodyString}');
        } else {
          print('[API][GET] Refresh failed');
        }
      }

      return _handleResponse<T>(response, converter);
    } catch (e, st) {
      print('[API][GET] Error: $e');
      print(st);
      throw ApiException(message: 'Failed to fetch data', originalException: e);
    }
  }

  // POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    required dynamic body,
    required T Function(dynamic) converter,
    Map<String, String>? headers,
  }) async {
    try {
      final url = '${_getConnect.httpClient.baseUrl}$endpoint';
      final usedHeaders = headers ?? ApiConstants.defaultHeaders;
      final encodedBody = jsonEncode(body);
      print('[API][POST] URL: $url');
      print('[API][POST] Headers: $usedHeaders');
      print('[API][POST] Body: $encodedBody');

      var response = await _getConnect.post(
        endpoint,
        encodedBody, // Encode as JSON string
        headers: usedHeaders,
      );

      print('[API][POST] Status: ${response.statusCode}');
      print('[API][POST] Body: ${response.bodyString}');

      // handle 401 - try refresh once
      // handle 401 - try refresh once
      // handle 401 - try refresh once
      if (response.statusCode == 401) {
        print('[API][POST] Received 401, attempting token refresh');

        // Avoid infinite loop if the 401 comes from the logout request itself
        // ALSO skip refresh for login/register - 401 here means bad credentials, not expired token
        if (endpoint.contains('logout') ||
            endpoint.contains('login') ||
            endpoint.contains('register')) {
          print('[API][POST] 401 on $endpoint - skipping refresh logic');
          // Just return the response so the specific API call can handle the 401
          return _handleResponse<T>(response, converter);
        } else {
          final auth = Get.find<AuthService>();
          final refreshed = await auth.refreshToken();
          if (refreshed) {
            print('[API][POST] Refresh succeeded, retrying request');
            // update headers with new token
            usedHeaders['Authorization'] =
                'Bearer ${Get.find<StorageService>().token}';
            response = await _getConnect.post(
              endpoint,
              encodedBody,
              headers: usedHeaders,
            );
            print('[API][POST] Retry Status: ${response.statusCode}');
            print('[API][POST] Retry Body: ${response.bodyString}');
          } else {
            print('[API][POST] Refresh failed - Session expired');
            // Force logout to clear invalid state
            await auth.logout();
            Get.offAllNamed('/login');
            throw ApiException(
              message: 'Session expired. Please login again.',
              statusCode: 401,
            );
          }
        }
      }

      return _handleResponse<T>(response, converter);
    } catch (e, st) {
      print('[API][POST] Error: $e');
      print(st);
      throw ApiException(
        message: 'Failed to send request',
        originalException: e,
      );
    }
  }

  // PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    required dynamic body,
    required T Function(dynamic) converter,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _getConnect.put(
        endpoint,
        body,
        headers: headers ?? ApiConstants.defaultHeaders,
      );

      return _handleResponse<T>(response, converter);
    } catch (e) {
      throw ApiException(
        message: 'Failed to update data',
        originalException: e,
      );
    }
  }

  // DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    required T Function(dynamic) converter,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _getConnect.delete(
        endpoint,
        headers: headers ?? ApiConstants.defaultHeaders,
      );

      return _handleResponse<T>(response, converter);
    } catch (e) {
      throw ApiException(
        message: 'Failed to delete data',
        originalException: e,
      );
    }
  }

  // Handle response
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic) converter,
  ) {
    print('[API][HANDLE] Status: ${response.statusCode}');
    print('[API][HANDLE] Body: ${response.bodyString}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body is Map
          ? response.body as Map<String, dynamic>
          : {};
      final data = body['data'] != null ? converter(body['data']) : null;
      return ApiResponse<T>(
        success: body['success'] ?? true,
        data: data,
        message: body['message'] as String?,
        statusCode: response.statusCode,
      );
    } else {
      // Try to extract a useful message and validation errors
      String message = response.statusText ?? 'An error occurred';
      final original = response.bodyString;
      if (response.body is Map) {
        final Map bodyMap = response.body as Map;
        if (bodyMap['message'] != null) {
          message = bodyMap['message'].toString();
        }
        // If there are validation errors, flatten them
        if (bodyMap['errors'] != null && bodyMap['errors'] is Map) {
          final Map errMap = bodyMap['errors'] as Map;
          final List<String> parts = [];
          errMap.forEach((key, val) {
            try {
              if (val is List && val.isNotEmpty) {
                parts.add('$key: ${val.join(', ')}');
              } else {
                parts.add('$key: $val');
              }
            } catch (_) {}
          });
          if (parts.isNotEmpty) message = '$message\n${parts.join('\n')}';
        }
      }

      throw ApiException(
        message: message,
        statusCode: response.statusCode,
        originalException: original,
      );
    }
  }
}
