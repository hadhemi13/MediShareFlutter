import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medishareflutter/services/auth_service.dart';
import 'package:medishareflutter/views/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  // Load the name and email from SharedPreferences

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _imageFile; // To store the picked image file
  String userName = "Welcome";
  String userEmail = "";

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Update the image
      });
    }
  }

  // Method to show image picker dialog
  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera); // Pick from camera
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery); // Pick from gallery
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
      _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName') ?? "Welcome";
    final email = prefs.getString('userEmail') ?? "";

    setState(() {
      userName = name;
      userEmail = email;
    });
  }

  // Future<String> _fetchUserName() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   var userId = await prefs.getString('userName');
  //   var userEmaill = await prefs.getString('userName');
  //   this.userName = userId as String;

  //   return userName; // Replace with your user ID logic
  // }

  // Future<String> _fetchUserEmail() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   var userEmail = await prefs.getString('userEmail');
  //   this.userEmail = userEmail as String;

  //   return userEmail!; // Replace with your user ID logic
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Profile Image
                            GestureDetector(
                              onTap: () {
                                _showImageSourceDialog(
                                    context); // Show image source dialog
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xF9F9F9F9),
                                backgroundImage: _imageFile != null
                                    ? FileImage(
                                        _imageFile!) // Display the picked image
                                    : const AssetImage('assets/profile.png')
                                        as ImageProvider,
                              ),
                            ),
                            SizedBox(width: 16),
                            // Profile Name and Email
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  this.userName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  this.userEmail,
                                  style: TextStyle(
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
              // Other options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
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

// Rest of the functions like _showEditProfileDialog, _showLogoutDialog, etc...

void _showEditPasswordDialog(BuildContext context) {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  bool isOldPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // Function to generate a secure password
  String _generateSecurePassword() {
    const chars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*";
    final random = Random.secure();
    return List.generate(10, (_) => chars[random.nextInt(chars.length)]).join();
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Old Password Field
                  TextFormField(
                    controller: oldPasswordController,
                    obscureText: !isOldPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Old Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isOldPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isOldPasswordVisible = !isOldPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Old password is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // New Password Field
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: !isNewPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isNewPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isNewPasswordVisible = !isNewPasswordVisible;
                          });
                        },
                      ),
                    ),
                    onTap: () async {
                      // Show dialog to choose password generation
                      final bool? generatePassword = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Generate Secure Password'),
                            content: const Text(
                                'Do you want to generate a secure password?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );

                      if (generatePassword == true) {
                        final generatedPassword = _generateSecurePassword();
                        setState(() {
                          newPasswordController.text = generatedPassword;
                          confirmPasswordController.text = generatedPassword;
                        });
                        _formKey.currentState
                            ?.validate(); // Trigger validation after update
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'New password is required.';
                      }
                      final passwordRegex = RegExp(
                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*])[A-Za-z\d!@#\$%^&*]{6,}$');
                      if (!passwordRegex.hasMatch(value)) {
                        return 'Password must include uppercase, lowercase, digit, and special character.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm New Password Field
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm password is required.';
                      } else if (value != newPasswordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
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
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final response = await _authService.changePassword(
                                oldPasswordController.text,
                                newPasswordController.text);
                            if (response.statusCode <= 205) {
                              Navigator.of(context).pop();
                            }
                            // Save password logic
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

void _showEditProfileDialog(BuildContext context) async {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();
  final prefs = await SharedPreferences.getInstance();
  final userName = prefs.getString("userName");
  final userEmail = prefs.getString("userEmail");
  if (userName != null) {
    nameController.text = userName;
  }
  if (userEmail != null) {
    emailController.text = userEmail;
  }
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.png'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'User Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required.';
                  } else if (value.length < 4) {
                    return 'Name must be at least 4 characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required.';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final response = await _authService.updateUserInfo(
                            nameController.text, emailController.text);
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          await prefs.setString(
                              "userEmail", emailController.text);
                          await prefs.setString(
                              "userName", nameController.text);
                          Navigator.of(context).pop();
                        }
                        // Save logic
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
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
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);
                  await prefs.setString('userId', "");
                  await prefs.setString('userName', "");
                  await prefs.setString('userEmail', "");
                  await prefs.setString('accessToken', "");
                  await prefs.setString('refreshToken', "");
                  // Implement your logout logic here
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ); // Close the dialog
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
