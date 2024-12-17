/*import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medishareflutter/models/clinique.dart';
import 'package:medishareflutter/utils/constants.dart';  // Import the Constants class

class CliniqueAPI {
  static String baseUrl = Constants.baseUrl;

  // Fetch all cliniques
  static Future<List<Clinique>> fetchCliniques() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl${Constants.fetchCliniques}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Clinique.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cliniques: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cliniques: $e');
    }
  }

  // Create a new clinique
  /*Future<void> createClinique(Clinique clinique) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${Constants.addClinic}'),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization if needed, for example:
          // 'Authorization': 'Bearer your_token',
        },
        body: json.encode(clinique.toJson()), // Ensure the toJson method is correct
      );

      if (response.statusCode == 201) {
        print('Clinique added successfully');
      } else {
        throw Exception('Failed to add clinique: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding clinique: $e');
    }
  }*/
  static Future<Clinique> createClinique(Clinique clinique) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${Constants.addClinic}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(clinique.toJson()), // Send only required fields
      );

      if (response.statusCode == 201) {
        // Parse the response to return the created Clinique object
        final responseData = json.decode(response.body)['data'];
        return Clinique.fromJson(responseData);
      } else {
        throw Exception('Failed to add clinique: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding clinique: $e');
    }
  }
}
*/
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medishareflutter/models/clinique.dart';
import 'package:medishareflutter/utils/constants.dart';  // Import the Constants class

class CliniqueAPI {
  static String baseUrl = Constants.baseUrl;

  // Fetch all cliniques
  static Future<List<Clinique>> fetchCliniques() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl${Constants.fetchCliniques}'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Clinique.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cliniques: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cliniques: $e');
    }
  }

  // Create a new clinique
  /*Future<void> createClinique(Clinique clinique) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${Constants.addClinic}'),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization if needed, for example:
          // 'Authorization': 'Bearer your_token',
        },
        body: json.encode(clinique.toJson()), // Ensure the toJson method is correct
      );

      if (response.statusCode == 201) {
        print('Clinique added successfully');
      } else {
        throw Exception('Failed to add clinique: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding clinique: $e');
    }
  }*/
  static Future<Clinique> createClinique(Clinique clinique) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${Constants.addClinic}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(clinique.toJson()), // Send only required fields
      );

      if (response.statusCode == 201) {
        // Parse the response to return the created Clinique object
        final responseData = json.decode(response.body)['data'];
        return Clinique.fromJson(responseData);
      } else {
        throw Exception('Failed to add clinique: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding clinique: $e');
    }
  }
}