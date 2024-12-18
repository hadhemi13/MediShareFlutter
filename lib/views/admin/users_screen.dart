import 'package:flutter/material.dart';
import 'package:medishareflutter/viewModels/banned.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radiologists List'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ChangeNotifierProvider(
        create: (context) => BannedUsersViewModel()..fetchAllUsers(),
        child: Consumer<BannedUsersViewModel>(
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
                itemCount: viewModel.allUsers.length,
                padding: EdgeInsets.all(10),
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final user = viewModel.allUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade100,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/rad.png', // Replace with your image path
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      user.email, // Display email here
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Check if the user is banned
                        if (user.isBanned)
                          IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () {
                              // Show confirmation dialog for accepting the user as radiologist
                              _showConfirmationDialog(
                                context,
                                'Are you sure you want to accept this user as a radiologist?',
                                    () {
                                  // Perform the ban function if confirmed
                                  viewModel.toggleBanStatus(user.id); // Use user ID to identify the user
                                  Navigator.pop(context); // Close the dialog
                                },
                              );
                            },
                          )
                        else
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              // Show confirmation dialog for refusing to add the user as radiologist
                              _showConfirmationDialog(
                                context,
                                'Are you sure you want to refuse to add this user as a radiologist?',
                                    () {
                                  // Perform the ban function if confirmed
                                  viewModel.toggleBanStatus(user.id); // Use user ID to identify the user
                                  Navigator.pop(context); // Close the dialog
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // Confirmation dialog to ask user for action
  void _showConfirmationDialog(
      BuildContext context, String message, VoidCallback onConfirm) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmation"),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  onConfirm(); // Call the provided confirmation function
                },
                child: Text("Yes"),
              ),
            ],
          );
        },
      );
    });
  }
}
