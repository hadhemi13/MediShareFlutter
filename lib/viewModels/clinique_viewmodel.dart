/*import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:medishareflutter/models/clinique.dart';
import 'package:medishareflutter/utils/constants.dart';  // Import the Constants class

class CliniqueViewModel extends ChangeNotifier {
  List<Clinique> cliniques = [];
  LatLng? currentPosition;
  String? currentState; // Add a variable to store the user's state

  Future<void> fetchCliniques() async {
    try {
      // Use the correct base URL from the Constants class
      final url = Uri.parse('${Constants.baseUrl}${Constants.fetchCliniques}');

      // Send a GET request to the API
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response and extract the 'data' field
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the 'data' field which contains the list of cliniques
        List<dynamic> data = responseData['data'];

        // Map the data into Clinique objects
        cliniques = data.map((json) => Clinique.fromJson(json)).toList();

        // Notify listeners to update the UI
        notifyListeners();
      } else {
        print('Failed to load cliniques: ${response.statusCode}');
        // Handle the error appropriately
      }
    } catch (e) {
      print('Error fetching cliniques: $e');
      // You could handle specific errors, like network errors, here
    }
  }


  // Add a new clinique to the API
  /* Future<String> addClinique(Clinique clinique) async {
    try {
      final url = Uri.parse('${Constants.baseUrl}${Constants.addClinic}');
      final body = json.encode(clinique.toJson());

      final response = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
        // Add authorization if needed, for example:
        // 'Authorization': 'Bearer your_token',
      });

      if (response.statusCode == 201) {
        cliniques.add(clinique);
        notifyListeners();
        return 'Clinique ajoutée avec succès';
      } else if (response.statusCode == 404) {
        return 'Erreur : Ressource non trouvée (404)';
      } else {
        return 'Erreur inconnue : ${response.statusCode}';
      }
    } catch (e) {
      return 'Erreur : ${e.toString()}';
    }
  }*/
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

      if (response.statusCode == 201) {
        // Parse the backend response to get the full Clinique object
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Clinique newClinique = Clinique.fromJson(responseData['data']);

        // Add the new clinique (with region) to the list
        cliniques.add(newClinique);
        notifyListeners();

        return 'Clinique ajoutée avec succès';
      } else if (response.statusCode == 400) {
        return 'Erreur : Requête invalide (400)';
      } else {
        return 'Erreur inconnue : ${response.statusCode}';
      }
    } catch (e) {
      return 'Erreur : ${e.toString()}';
    }
  }

  /*Future<void> determinePosition() async {
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
*/
  Future<void> determinePosition() async {
    try {
      // Request permission for location access
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('Location permission denied');
        currentPosition =
            LatLng(36.8065, 10.1815); // Default location (e.g., Tunisia)
        currentState = 'Tunisia'; // Set default country as Tunisia
        notifyListeners(); // Notify listeners to update UI
      } else {
        // Get the current position
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        currentPosition = LatLng(position.latitude, position.longitude);

        // Use GeocodingPlatform for reverse geocoding
        if (GeocodingPlatform.instance != null) {
          List<Placemark> placemarks = await GeocodingPlatform.instance!
              .placemarkFromCoordinates(position.latitude, position.longitude);
          Placemark place = placemarks[0];

          // Check if the user is in Tunisia
          currentState = place.country;
          notifyListeners(); // Notify listeners to update UI
        } else {
          print('GeocodingPlatform is not available');
        }
      }
    } catch (e) {
      print('Error getting location: $e');
      currentPosition =
          LatLng(36.8065, 10.1815); // Default location (e.g., Tunisia)
      currentState = 'Tunisia'; // Default country
      notifyListeners(); // Notify listeners to update UI
    }
  }

  bool canAddClinique() {
    print("Current State: $currentState"); // Debugging line
    return currentState == 'Tunisia'; // Check if the user is in Tunisia
  }
}*/
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
  LatLng? currentPosition;
  String? currentState;  // Add a variable to store the user's state

  Future<void> fetchCliniques() async {
    try {
      // Use the correct base URL from the Constants class
      final url = Uri.parse('${Constants.baseUrl}${Constants.fetchCliniques}');

      // Send a GET request to the API
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response and extract the 'data' field
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the 'data' field which contains the list of cliniques
        List<dynamic> data = responseData['data'];

        // Map the data into Clinique objects
        cliniques = data.map((json) => Clinique.fromJson(json)).toList();

        // Notify listeners to update the UI
        notifyListeners();
      } else {
        print('Failed to load cliniques: ${response.statusCode}');
        // Handle the error appropriately
      }
    } catch (e) {
      print('Error fetching cliniques: $e');
      // You could handle specific errors, like network errors, here
    }
  }


  // Add a new clinique to the API
  /* Future<String> addClinique(Clinique clinique) async {
    try {
      final url = Uri.parse('${Constants.baseUrl}${Constants.addClinic}');
      final body = json.encode(clinique.toJson());

      final response = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
        // Add authorization if needed, for example:
        // 'Authorization': 'Bearer your_token',
      });

      if (response.statusCode == 201) {
        cliniques.add(clinique);
        notifyListeners();
        return 'Clinique ajoutée avec succès';
      } else if (response.statusCode == 404) {
        return 'Erreur : Ressource non trouvée (404)';
      } else {
        return 'Erreur inconnue : ${response.statusCode}';
      }
    } catch (e) {
      return 'Erreur : ${e.toString()}';
    }
  }*/
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

      if (response.statusCode == 201) {
        // Parse the backend response to get the full Clinique object
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Clinique newClinique = Clinique.fromJson(responseData['data']);

        // Add the new clinique (with region) to the list
        cliniques.add(newClinique);
        notifyListeners();

        return 'Clinique ajoutée avec succès';
      } else if (response.statusCode == 400) {
        return 'Erreur : Requête invalide (400)';
      } else {
        return 'Erreur inconnue : ${response.statusCode}';
      }
    } catch (e) {
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


}