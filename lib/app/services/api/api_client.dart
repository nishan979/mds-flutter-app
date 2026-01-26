import 'package:get/get.dart';
import 'dart:convert';
import 'api_constants.dart';
import 'api_models.dart';

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
      print('[API][GET] Headers: ${headers ?? ApiConstants.defaultHeaders}');

      final response = await _getConnect.get(
        endpoint,
        headers: headers ?? ApiConstants.defaultHeaders,
      );

      print('[API][GET] Status: ${response.statusCode}');
      print('[API][GET] Body: ${response.bodyString}');

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

      final response = await _getConnect.post(
        endpoint,
        encodedBody, // Encode as JSON string
        headers: usedHeaders,
      );

      print('[API][POST] Status: ${response.statusCode}');
      print('[API][POST] Body: ${response.bodyString}');

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
      final message =
          (response.body is Map && (response.body as Map)['message'] != null)
          ? (response.body as Map)['message']
          : response.statusText ?? 'An error occurred';
      throw ApiException(
        message: message,
        statusCode: response.statusCode,
        originalException: response.bodyString,
      );
    }
  }
}
