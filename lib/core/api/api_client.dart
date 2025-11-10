import 'dart:convert';
import 'dart:io'; // Import for SocketException
import 'dart:async'; // Import for TimeoutException
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

/// A robust API client for making authenticated HTTP requests.
/// It handles token injection, network errors, timeouts, and 401 logout/redirection.
class ApiClient {
  final String baseUrl = ApiConstants.baseUrl;
  final GlobalKey<NavigatorState>? navigatorKey;

  // Define a default timeout duration
  static const Duration timeoutDuration = Duration(seconds: 30);

  ApiClient({this.navigatorKey});

  /// Performs a GET request.
  Future<http.Response> get(String endpoint) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(timeoutDuration);

      return _handleResponse(response, prefs);
    } on SocketException {
      // Thrown when the device has no internet connection or cannot resolve host
      throw const SocketException('No internet connection. Please check your network settings.');
    } on TimeoutException {
      // Thrown when the request exceeds the defined timeout
      throw TimeoutException('The request timed out. The server may be unreachable or slow.');
    } catch (e) {
      // Catch any other unexpected exceptions (e.g., URI parsing errors)
      throw Exception('An unexpected error occurred during GET request: $e');
    }
  }

  /// Performs a POST request with JSON data.
  Future<http.Response> post(String endpoint, dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      ).timeout(timeoutDuration);

      return _handleResponse(response, prefs);
    } on SocketException {
      throw const SocketException('No internet connection. Please check your network settings.');
    } on TimeoutException {
      throw TimeoutException('The request timed out. The server may be unreachable or slow.');
    } catch (e) {
      throw Exception('An unexpected error occurred during POST request: $e');
    }
  }

  /// Centralized response handler for checking status codes and redirection.
  Future<http.Response> _handleResponse(http.Response response, SharedPreferences prefs) async {
    if (response.statusCode == 401) {
      // Handle Unauthorized: clear session and redirect to login
      await prefs.clear();
      // Use pushNamedAndRemoveUntil to clear the navigation stack
      navigatorKey?.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
      // Stop further execution by throwing an exception
      throw Exception('Unauthorized access. Redirecting to login screen.');
    } else if (response.statusCode >= 400) {
      // Handle other client (4xx) and server (5xx) errors
      String errorBody = response.body.isNotEmpty ? response.body : 'Server returned status code ${response.statusCode}';

      // Try to parse JSON message if available
      try {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse is Map && jsonResponse.containsKey('message')) {
          errorBody = jsonResponse['message'] as String;
        }
      } catch (_) {
        // Ignore parsing errors, use raw body or default message
      }

      throw Exception('API Error ${response.statusCode}: $errorBody');
    }

    // Return the response for 2xx status codes
    return response;
  }
}
