
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';  // Add this import
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:medishareflutter/models/clinique.dart';
import 'package:medishareflutter/utils/constants.dart';  // Import the Constants class

class CliniqueViewModel extends ChangeNotifier {
  List<Clinique> cliniques = [];
  bool isLoading = false;
  String errorMessage = '';
  LatLng? currentPosition;
  String successMessage = '';

  // Add a method to handle the success message
  void setSuccessMessage(String message) {
    successMessage = message;
    notifyListeners();
  }

  // Update your deleteClinique and updateClinique methods to call setSuccessMessage
  Future<String> deleteClinique(String id) async {
    try {
      final url = Uri.parse('${Constants.baseUrl}${Constants.deleteClinic}/$id');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setSuccessMessage('Clinic deleted successfully');
        return 'Clinic deleted successfully';
      } else {
        return 'Error deleting clinic: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error deleting clinic: $e';
    }
  }

  Future<String> updateClinique(String id, Clinique updatedClinique) async {
    try {
      final url = Uri.parse('${Constants.baseUrl}${Constants.updateClinic}/$id');
      final Map<String, dynamic> requestBody = updatedClinique.toJson();

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        setSuccessMessage('Clinic updated successfully');
        return 'Clinic updated successfully';
      } else {
        return 'Error updating clinic: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error updating clinic: $e';
    }
  }
  Future<void> fetchCliniques() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final url = Uri.parse('${Constants.baseUrl}${Constants.fetchCliniques}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Response Data: ${responseData['data']}'); // Debugging the response
        cliniques = (responseData['data'] as List)
            .map((json) => Clinique.fromJson(json))
            .toList();
      } else {
        errorMessage = 'Failed to load clinics: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Error fetching clinics: $e';
    }
    finally {
      isLoading = false;
      notifyListeners();
    }
  }



  Future<String> addClinique(Clinique clinique) async {
    try {
      final url = Uri.parse('${Constants.baseUrl}${Constants.addClinic}');

      // Convert Clinique object to JSON (only required fields)
      final Map<String, dynamic> requestBody = clinique.toJson();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        // Parse the backend response to get the full Clinique object
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('data')) {
          final Clinique newClinique = Clinique.fromJson(responseData['data']);
          cliniques.add(newClinique);
          notifyListeners();
          return 'Clinic added successfully';
        } else {
          return 'Erreur : La réponse ne contient pas les données attendues.';
        }
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> errorData = json.decode(response.body);
        return 'Erreur : ${errorData['message'] ?? 'Requête invalide (400)'}';
      } else {
        return 'Erreur inconnue : ${response.statusCode}';
      }
    } catch (e) {
      print("Erreur dans addClinique: ${e.toString()}");
      return 'Erreur : ${e.toString()}';
    }


  }Future<void> determinePosition() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        print('Location permission denied');
        currentPosition = LatLng(36.8065, 10.1815); // Default location (e.g., Tunisia)
      } else {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        currentPosition = LatLng(position.latitude, position.longitude);
      }
    } catch (e) {
      print('Error getting location: $e');
      currentPosition = LatLng(36.8065, 10.1815); // Default location (e.g., Tunisia)
    }
    notifyListeners(); // Notify listeners to update UI
  }

/*
  Future<String> updateClinique(String id, Clinique updatedClinique) async {
    try {
      final url = Uri.parse('${Constants.baseUrl}${Constants.updateClinic}/$id');
      print('hani nupdati ye hadhemi : $url');

      final Map<String, dynamic> requestBody = updatedClinique.toJson();

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final updatedClinique = Clinique.fromJson(responseData['data']);
          final index = cliniques.indexWhere((c) => c.id == id);
          if (index != -1) {
            cliniques[index] = updatedClinique;
            notifyListeners();
            return 'Clinic updated successfully';
          }
        }
        return 'Failed to update clinic: ${responseData['message']}';
      } else {
        return 'Error updating clinic: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error updating clinic: $e';
    }
  }


  Future<String> deleteClinique(String id) async {
    try {
      final url = Uri.parse('${Constants.baseUrl}${Constants.deleteClinique}/$id');
      print("hadhemi ena delete c'est bon  : $url");

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return 'Clinique deleted successfully';
        } else {
          return 'Error: ${responseData['message']}';
        }
      } else {
        return 'Failed to delete clinique: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

*/
}