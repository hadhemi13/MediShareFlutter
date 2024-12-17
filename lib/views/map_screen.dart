/*import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // For coordinates
import 'package:geolocator/geolocator.dart'; // For geolocation
import 'package:provider/provider.dart';

import '../models/clinique.dart';
import '../viewmodels/clinique_viewmodel.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedPosition;
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    // Fetch the clinics data and the user's location when the screen is initialized
    Provider.of<CliniqueViewModel>(context, listen: false).fetchCliniques();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.requestPermission();

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting location: $e');
      // Optionally, handle error by showing a default position
      setState(() {
        currentPosition =
            LatLng(36.8065, 10.1815); // Default location (e.g., Tunisia)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CliniqueViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Cliniques Map")),
      body: currentPosition == null
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialZoom: 11,
              onTap: (tapPosition, point) {
                setState(() {
                  selectedPosition = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  // Existing clinic markers
                  ...viewModel.cliniques.map((clinique) {
                    return Marker(
                      point: LatLng(clinique.latitude, clinique.longitude),
                      width: 60.0,
                      height: 60.0,
                      child: Icon(Icons.location_on, color: Colors.green),
                    );
                  }).toList(),
                  // Temporary marker for adding new clinic
                  if (selectedPosition != null)
                    Marker(
                      point: selectedPosition!,
                      width: 60.0,
                      height: 60.0,
                      child: GestureDetector(
                        onTap: () => _showAddDialog(context, selectedPosition!),
                        child: Icon(Icons.add_location, color: Colors.red),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

 /* void _showAddDialog(BuildContext context, LatLng position) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController regionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ajouter une clinique"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nom de la clinique"),
              ),
              TextField(
                controller: regionController,
                decoration: InputDecoration(labelText: "Région"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                // Static user ID (you can change this to whatever ID you want)
                const staticUserId = '6747c71d272632716f161c76'; // Example static user ID

                final clinique = Clinique(
                  nom: nameController.text,
                  region: regionController.text,
                  latitude: position.latitude,
                  longitude: position.longitude,
                  createdBy: staticUserId, // Use the static user ID here
                );

                // Call the addClinique method and get the result
                String result = await Provider.of<CliniqueViewModel>(context, listen: false)
                    .addClinique(clinique);

                // Show the result in an alert
                Navigator.pop(context); // Close the add clinic dialog
                _showResultDialog(context, result); // Show the result dialog
              },
              child: Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }*/
  void _showAddDialog(BuildContext context, LatLng position) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ajouter une clinique"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nom de la clinique"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                // Static user ID (you can change this to whatever ID you want)
                const staticUserId = '6747c71d272632716f161c76'; // Example static user ID

                final clinique = Clinique(
                  nom: nameController.text,
                  latitude: position.latitude,
                  longitude: position.longitude,
                  createdBy: staticUserId, // Use the static user ID here
                );

                // Call the addClinique method and get the result
                String result = await Provider.of<CliniqueViewModel>(context, listen: false)
                    .addClinique(clinique);

                // Show the result in an alert
                Navigator.pop(context); // Close the add clinic dialog
                _showResultDialog(context, result); // Show the result dialog
              },
              child: Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }


  void _showResultDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message.contains("succès") ? "Succès" : "Erreur"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (message.contains("succès")) {
                  // Fetch updated cliniques after adding a new one
                  Provider.of<CliniqueViewModel>(context, listen: false).fetchCliniques();
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}*//*
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // For coordinates
import 'package:geolocator/geolocator.dart'; // For geolocation
import 'package:provider/provider.dart';

import '../models/clinique.dart';
import '../viewmodels/clinique_viewmodel.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedPosition;
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    // Fetch the clinics data and the user's location when the screen is initialized
    Provider.of<CliniqueViewModel>(context, listen: false).fetchCliniques();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.requestPermission();

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting location: $e');
      // Optionally, handle error by showing a default position
      setState(() {
        currentPosition =
            LatLng(36.8065, 10.1815); // Default location (e.g., Tunisia)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CliniqueViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Cliniques Map")),
      body: currentPosition == null
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialZoom: 11,
              onTap: (tapPosition, point) {
                setState(() {
                  selectedPosition = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  // Existing clinic markers with clinic icon
                  ...viewModel.cliniques.map((clinique) {
                    return Marker(
                      point: LatLng(clinique.latitude, clinique.longitude),
                      width: 80.0,
                      height: 60.0,
                      child: Column(
                        children: [
                          // Remplacer l'icône par une image
                          Image.asset(
                            'assets/hospital.png',  // Chemin vers l'image de la clinique
                            width: 30.0,  // Largeur de l'image
                            height: 30.0, // Hauteur de l'image
                          ),
                          // Texte sous l'image
                          Flexible(  // Use Flexible to allow the text to take up the remaining space
                            child: Text(
                              clinique.nom, // Nom de la clinique sous le marqueur
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,  // Add ellipsis if text overflows
                              maxLines: 1,  // Limit to 1 line
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  // Temporary marker for adding new clinic
                  if (selectedPosition != null)
    Marker(
    point: selectedPosition!,
    width: 90.0,
    height: 50.0,
    child: GestureDetector(
    onTap: () => _showAddDialog(context, selectedPosition!),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(
    Icons.add_location,
    color: Colors.blue,
    size: 30,
    ),
    SizedBox(height: 5),  // Space between icon and text
    Flexible(
    child: Text(
    'Add Clinic Here',  // Text below the icon
    style: TextStyle(
    fontSize: 10,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    ),
    overflow: TextOverflow.ellipsis, // Truncate text if needed
    ),
    ),
    ],
    ),
    ),
    )


    ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, LatLng position) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ajouter une clinique"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nom de la clinique"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                // Static user ID (you can change this to whatever ID you want)
                const staticUserId = '6747c71d272632716f161c76';

                final clinique = Clinique(
                  nom: nameController.text,
                  latitude: position.latitude,
                  longitude: position.longitude,
                  createdBy: staticUserId,
                );

                // Call the addClinique method and get the result
                String result = await Provider.of<CliniqueViewModel>(context,
                    listen: false)
                    .addClinique(clinique);

                // Show the result in an alert
                Navigator.pop(context);
                _showResultDialog(context, result);
              },
              child: Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  void _showResultDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message.contains("succès") ? "Succès" : "Erreur"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (message.contains("succès")) {
                  // Fetch updated cliniques after adding a new one
                  Provider.of<CliniqueViewModel>(context, listen: false)
                      .fetchCliniques();
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}*/
// map_screen.dart
// map_screen.dart


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:medishareflutter/models/clinique.dart';
import 'package:medishareflutter/viewmodels/clinique_viewmodel.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedPosition;

  @override
  void initState() {
    super.initState();
    // Fetch the clinics data and the user's location when the screen is initialized
    Provider.of<CliniqueViewModel>(context, listen: false).fetchCliniques();
    // Call determinePosition to get the user's current location
    Provider.of<CliniqueViewModel>(context, listen: false).determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CliniqueViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: Text("Cliniques Map")),
          body: viewModel.currentPosition == null
              ? Center(child: CircularProgressIndicator()) // Show loading spinner
              : Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: viewModel.currentPosition ?? LatLng(0.0, 0.0),
                  initialZoom: 11,
                  onTap: (tapPosition, point) {
                    setState(() {
                      selectedPosition = point;
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      // Existing clinic markers with clinic icon
                      ...viewModel.cliniques.map((clinique) {
                        return Marker(
                          point: LatLng(clinique.latitude, clinique.longitude),
                          width: 80.0,
                          height: 60.0,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/hospital.png',  // Clinic icon
                                width: 30.0,
                                height: 30.0,
                              ),
                              Flexible(
                                child: Text(
                                  clinique.nom, // Clinic name
                                  style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      // Temporary marker for adding new clinic
                      if (selectedPosition != null)
                        Marker(
                          point: selectedPosition!,
                          width: 90.0,
                          height: 50.0,
                          child: GestureDetector(
                            onTap: () => _showAddDialog(context, selectedPosition!),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_location,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                                SizedBox(height: 5),
                                Flexible(
                                  child: Text(
                                    'Add Clinic Here',
                                    style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  void _showAddDialog(BuildContext context, LatLng position) {
    final TextEditingController nameController = TextEditingController();
    final distance = Distance(); // Distance calculator from latlong2 package
    final thresholdDistance = 5; // Distance threshold in meters

    final viewModel = Provider.of<CliniqueViewModel>(context, listen: false);

    // Check if the selected position is near any existing clinic
    bool isNearExistingClinic = false;

    for (var clinique in viewModel.cliniques) {
      final clinicPosition = LatLng(clinique.latitude, clinique.longitude);
      final calculatedDistance = distance.as(LengthUnit.Meter, position, clinicPosition);

      // Print the calculated distance for debugging purposes
      print("Checking clinic at (${clinique.latitude}, ${clinique.longitude})");
      print("Distance to selected position: $calculatedDistance meters");

      // If the calculated distance is within the threshold, set isNearExistingClinic to true
      if (calculatedDistance <= thresholdDistance) {
        isNearExistingClinic = true;
        break; // No need to check further if a nearby clinic is found
      }
    }

    if (isNearExistingClinic) {
      // Show a dialog if the position is too close to an existing clinic
      _showResultDialog(context, "Une clinique existe déjà à proximité. Impossible d'ajouter.");
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ajouter une clinique"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nom de la clinique"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () async {
                const staticUserId = '6747c71d272632716f161c76';

                final clinique = Clinique(
                  nom: nameController.text,
                  latitude: position.latitude,
                  longitude: position.longitude,
                  createdBy: staticUserId,
                );

                String result = await viewModel.addClinique(clinique);

                Navigator.pop(context);

                setState(() {
                  selectedPosition = null;
                });

                _showResultDialog(context, result);
              },
              child: Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }
  void _showResultDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message.contains("succès") ? "Succès" : "Erreur"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (message.contains("succès")) {
                  // Fetch updated cliniques after adding a new one
                  Provider.of<CliniqueViewModel>(context, listen: false).fetchCliniques();
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}