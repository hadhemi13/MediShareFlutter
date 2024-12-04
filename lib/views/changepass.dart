import 'dart:math';
import 'package:flutter/material.dart';
import 'package:medishareflutter/views/login.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Variables to toggle password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool isPasswordValid = true;
  bool isConfirmPasswordValid = true;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String passwordError = '';
  String confirmPasswordError = '';
  String generatedPassword = '';

  // Password Validation Rules
  bool isPasswordValidFormat(String password) {
    // Password must be at least 8 characters long, contain a number, a lowercase letter, an uppercase letter, and a special character
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*()_+\-=\[\]{};":\\|,.<>\/?]).{8,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  // Method to generate a secure password
  String generateSecurePassword() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()_-+=<>?';
    Random random = Random();
    String password = List.generate(12, (index) => characters[random.nextInt(characters.length)]).join();
    return password;
  }

  void generateSecurePasswordAndFill() {
    setState(() {
      generatedPassword = generateSecurePassword();
      passwordController.text = generatedPassword;
      confirmPasswordController.text = generatedPassword;
    });
  }

  void _showPasswordSuggestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Generate Secure Password'),
          content: Text('Would you like to generate a secure password for your account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Cancel action: Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('No, I\'ll enter my own'),
            ),
            TextButton(
              onPressed: () {
                // Generate secure password and fill it in both fields
                generateSecurePasswordAndFill();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes, generate one'),
            ),
          ],
        );
      },
    );
  }

  // Function to show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,  // Prevents dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Center(child: Text("Password Updated")),
          content: Text("Your password has been updated successfully."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Center(child: Text("OK")),
            ),
          ],
        );
      },
    );
  }

  // Validate form
  void validateForm() {
    setState(() {
      // Check if password is valid
      if (passwordController.text.isEmpty) {
        isPasswordValid = false;
        passwordError = 'Password is required';
      } else if (!isPasswordValidFormat(passwordController.text)) {
        isPasswordValid = false;
        passwordError = 'Password must contain at least 8 characters, including uppercase, lowercase, a number, and a special character';
      } else {
        isPasswordValid = true;
        passwordError = '';
      }

      // Check if confirm password matches password
      if (confirmPasswordController.text.isEmpty) {
        isConfirmPasswordValid = false;
        confirmPasswordError = 'Confirm password is required';
      } else if (confirmPasswordController.text != passwordController.text) {
        isConfirmPasswordValid = false;
        confirmPasswordError = 'Passwords do not match';
      } else {
        isConfirmPasswordValid = true;
        confirmPasswordError = '';
      }

      // If the form is valid, show success dialog
      if (isPasswordValid && isConfirmPasswordValid) {
        _showSuccessDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Change Password"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(  // Use SingleChildScrollView to make the screen scrollable if content overflows
            child: Column(
              children: [
                const SizedBox(height: 30), // Space after the image

                // Image with responsive width and height
                Image.asset(
                  'assets/change.png', // Path to the image
                  height: MediaQuery.of(context).size.height * 0.3, // Responsive height
                  width: MediaQuery.of(context).size.width * 0.6,   // Responsive width
                ),
                const SizedBox(height: 30), // Space after the image

                // Text with center alignment and responsive font size
                const Text(
                  "Enter your new password",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,  // Center the text
                ),
                const SizedBox(height: 30), // Space between text and input fields

                // Password TextField with validation
                TextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0xFF113155), // Default border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0xFF113155), // Focused border color
                        width: 1, // You can adjust the border width
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(0xFF113155),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  onTap: () {
                    // Show password suggestion dialog when the field is tapped
                    _showPasswordSuggestionDialog(context);
                  },
                ),
                if (!isPasswordValid)
                  Text(
                    passwordError,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20),

                // Confirm Password TextField with validation
                TextField(
                  controller: confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0xFF113155), // Default border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Color(0xFF113155), // Focused border color
                        width: 1, // You can adjust the border width
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(0xFF113155),
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                if (!isConfirmPasswordValid)
                  Text(
                    confirmPasswordError,
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 30),

                // Change Password Button with validation
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                  height: MediaQuery.of(context).size.height * 0.06, // Responsive height
                  child: ElevatedButton(
                    onPressed: () {
                      validateForm();  // Validate form on button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF90CAF9), // Same background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                    child: const Text(
                      "Change Password",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
