import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:medishareflutter/models/clinique.dart';
import 'package:medishareflutter/viewModels/clinique_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedPosition;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<CliniqueViewModel>(context, listen: false);
    viewModel.fetchCliniques();
    viewModel.determinePosition();

    Future.delayed(Duration.zero, () {
      _showInfoDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CliniqueViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: Text("Clinics List")),
          body: viewModel.currentPosition == null
              ? Center(child: CircularProgressIndicator())
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
                      ...viewModel.cliniques.map((clinique) {
                        return Marker(
                          point: LatLng(clinique.latitude, clinique.longitude),
                          width: 80.0,
                          height: 60.0,
                          child: GestureDetector(
                            onTap: () => _showEditDialog(context, clinique),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/hospital.png',
                                  width: 30.0,
                                  height: 30.0,
                                ),
                                Flexible(
                                  child: Text(
                                    clinique.nom,
                                    style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
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
                                Icon(Icons.add_location, color: Colors.blue, size: 30),
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

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Information"),
          content: Text("If you want to add a new clinic, click on the map."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog(BuildContext context, LatLng position) {
    final TextEditingController nameController = TextEditingController();
    final viewModel = Provider.of<CliniqueViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add new clinic"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Clinic Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final userId = prefs.getString('userId');

                if (userId != null) {
                  final clinique = Clinique(
                    nom: nameController.text,
                    latitude: position.latitude,
                    longitude: position.longitude,
                    createdBy: userId,
                  );

                  String result = await viewModel.addClinique(clinique);

                  Navigator.pop(context);
                  setState(() {
                    selectedPosition = null;
                  });

                  _showResultDialog(context, result);
                } else {
                  _showResultDialog(context, 'Erreur : Identifiant utilisateur introuvable.');
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Clinique clinique) {
    final TextEditingController nameController = TextEditingController(text: clinique.nom);
    final viewModel = Provider.of<CliniqueViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Clinic"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Clinic Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final result = await viewModel.updateClinique(clinique.id!, Clinique(
                  id: clinique.id,
                  nom: nameController.text,
                  latitude: clinique.latitude,
                  longitude: clinique.longitude,
                  createdBy: clinique.createdBy,
                ));

                Navigator.pop(context);
                _showResultDialog(context, result);
              },
              child: Text("Update"),
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
        bool isSuccess = message.toLowerCase().contains("succès") || message.toLowerCase().contains("success");

        return AlertDialog(
          title: Text(isSuccess ? "Success" : "Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (isSuccess) {
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
