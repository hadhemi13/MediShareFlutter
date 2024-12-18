import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medishareflutter/models/user.dart';
import 'package:medishareflutter/utils/constants.dart';

class BannedUsersViewModel extends ChangeNotifier {
  List<User> _allUsers = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<User> get allUsers => _allUsers;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch all users from the backend (including both banned and non-banned users)
  Future<void> fetchAllUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('${Constants.baseUrl}auth/banned');  // Assuming this endpoint returns all users
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          _errorMessage = 'No users found.';
        } else {
          _allUsers = data.map((userJson) => User.fromJson(userJson)).toList();
        }
      } else {
        _errorMessage = 'Failed to load users. Status code: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle the ban status of a user
  Future<void> toggleBanStatus(String userId) async {
    final url = Uri.parse('${Constants.baseUrl}auth/user-banne/$userId');
    print("hani hene : $url");
    try {
      final response = await http.put(url);

      if (response.statusCode == 200) {
        // Successfully updated the user's ban status
        final data = json.decode(response.body);
        final isBanned = data['isBanned'];

        // Update the user in the local list
        final userIndex = _allUsers.indexWhere((user) => user.id == userId);
        if (userIndex != -1) {
          _allUsers[userIndex].isBanned = isBanned;
        }
        notifyListeners();
      } else {
        _errorMessage = 'Failed to update ban status. Status code: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }
  }

}
