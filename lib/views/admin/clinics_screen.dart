import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medishareflutter/models/clinique.dart';
import 'package:medishareflutter/viewModels/clinique_viewmodel.dart';

class ClinicsScreen extends StatelessWidget {
  const ClinicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinics List'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddClinicDialog(context);
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => CliniqueViewModel()..fetchCliniques(),
        child: Consumer<CliniqueViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage.isNotEmpty) {
              return Center(child: Text(viewModel.errorMessage));
            }

            return Container(
              color: Colors.white,
              child: ListView.separated(
                itemCount: viewModel.cliniques.length,
                padding: const EdgeInsets.all(10),
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final clinic = viewModel.cliniques[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade100,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/hospital.png', // Replace with your clinic image path
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    title: Text(
                      clinic.nom,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      clinic.region ?? 'Unknown region', // Provide a default value
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditDialog(context, clinic, viewModel);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showConfirmationDialog(
                              context,
                              'Are you sure you want to delete this clinic?',
                                  () {
                                viewModel.deleteClinique(clinic.id!).then((_) {
                                  _showSuccessDialog(
                                    context,
                                    'Clinic deleted successfully',
                                  );
                                  viewModel.fetchCliniques(); // Refresh the list
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      print('Clinic ID: ${clinic.id}');
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: onConfirm,
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(
      BuildContext context, Clinique clinic, CliniqueViewModel viewModel) {
    final TextEditingController nameController =
    TextEditingController(text: clinic.nom ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Clinic"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Clinic Name"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (clinic.id != null) {
                  clinic.nom = nameController.text;
                  Navigator.pop(context); // Close the dialog

                  viewModel.updateClinique(clinic.id!, clinic).then((_) {
                    _showSuccessDialog(
                      context,
                      'Clinic updated successfully',
                    );
                    viewModel.fetchCliniques(); // Refresh the list
                  });
                } else {
                  print('Clinic ID is null. Cannot update.');
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showAddClinicDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController latitudeController = TextEditingController();
    final TextEditingController longitudeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Clinic"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Clinic Name"),
              ),
              TextField(
                controller: latitudeController,
                decoration: const InputDecoration(labelText: "Latitude"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: longitudeController,
                decoration: const InputDecoration(labelText: "Longitude"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final newClinic = Clinique(
                  nom: nameController.text,
                  latitude: double.tryParse(latitudeController.text) ?? 0.0,
                  longitude: double.tryParse(longitudeController.text) ?? 0.0,
                  createdBy: 'user_id', // Replace with actual user ID
                );

                // Call the addClinique method from viewModel
                Provider.of<CliniqueViewModel>(context, listen: false)
                    .addClinique(newClinic)
                    .then((message) {
                  // Close the add clinic dialog first
                  Navigator.pop(context); // Close the add clinic dialog

                  // Show success dialog
                  _showSuccessDialog(context, message);

                  // Fetch the updated list of clinics after adding
                  Provider.of<CliniqueViewModel>(context, listen: false)
                      .fetchCliniques();
                }).catchError((error) {
                  // Handle error if needed
                  _showErrorDialog(context, 'Failed to add clinic: $error');
                });

              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the success dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

}
