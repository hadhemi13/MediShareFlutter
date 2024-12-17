import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medishareflutter/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // State variables
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Method to handle login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final response = await _authService.login({
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        final data =
            jsonDecode(response.body); // Assuming response.body contains JSON
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', data['userId']);
        await prefs.setString('userName', data['userName']);
        await prefs.setString('userEmail', data['userEmail']);
        await prefs.setString('accessToken', data['accessToken']);
        await prefs.setString('refreshToken', data['refreshToken']);
        await prefs.setString('userRole', data['userRole']);

        // Parse token or user data if needed
        // final data = jsonDecode(response.body);
        _setLoading(false);
        return true; // Login successful
      } else {
        _setErrorMessage('Login failed: ${response.body}');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setErrorMessage('An error occurred: $e');
      _setLoading(false);
      return false;
    }
  }

  // Helper methods to update state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Clear error message
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
