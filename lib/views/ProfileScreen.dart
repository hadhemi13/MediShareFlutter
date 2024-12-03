import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/backgroundprof.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Profile Card
                  Positioned(
                    top: 160,
                    left: 16,
                    right: 16,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child:const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Profile Image
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xF9F9F9F9),
                              backgroundImage: AssetImage('assets/hadh.jpg'),
                            ),
                             SizedBox(width: 16),
                            // Profile Name and Email
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Guest',
                                  style:  TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Guest@esprit.tn',
                                  style:  TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildOptionCard(
                      context,
                      icon: Icons.dark_mode,
                      title: 'Dark mode',
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildOptionCard(
                      context,
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _showEditProfileDialog(context);
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildOptionCard(
                      context,
                      icon: Icons.lock,
                      title: 'Change Password',
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _showEditPasswordDialog(context);
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildOptionCard(
                      context,
                      icon: Icons.logout,
                      title: 'Logout',
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget trailing,
        VoidCallback? onTap,

      }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap, // Add onTap callback to the ListTile
        leading: Icon(icon, color: Colors.grey[700]),
        title: Text(title),
        trailing: trailing,
      ),
    );
  }
}
void _showEditProfileDialog(BuildContext context) {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image in the dialog
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/hadh.jpg'),
            ),
            const SizedBox(height: 16),
            // Email and Name fields
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'User name',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Buttons for Save and Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Handle the saving logic here
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
void _showEditPasswordDialog(BuildContext context) {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image in the dialog
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/hadh.jpg'),
            ),
            const SizedBox(height: 16),
            // Old Password field with eye icon
            TextField(
              controller: oldPasswordController,
              obscureText: obscureOldPassword,
              decoration: InputDecoration(
                labelText: 'Old Password',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureOldPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Toggle the visibility
                    obscureOldPassword = !obscureOldPassword;
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // New Password field with eye icon
            TextField(
              controller: newPasswordController,
              obscureText: obscureNewPassword,
              decoration: InputDecoration(
                labelText: 'New Password',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Toggle the visibility
                    obscureNewPassword = !obscureNewPassword;
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Confirm New Password field with eye icon
            TextField(
              controller: confirmPasswordController,
              obscureText: obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Toggle the visibility
                    obscureConfirmPassword = !obscureConfirmPassword;
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Buttons for Save and Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Handle the saving logic here
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

// Show logout confirmation dialog
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Logout",
          textAlign: TextAlign.center, // Center the title
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: const Text(
          "Are you sure you want to log out?",
          textAlign: TextAlign.center, // Center the message
        ),
        actions: <Widget>[
          // Cancel Button
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween, // This spreads the buttons to the ends
            children: [
              const SizedBox(width: 25),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red, // Red color for cancel button
                  ),
                ),
              ),
              const SizedBox(width: 40),
              TextButton(
                onPressed: () {
                  // Implement your logout logic here
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Confirm"),
              ),
            ],
          )

          // OK Button

        ],
      );
    },
  );
}


