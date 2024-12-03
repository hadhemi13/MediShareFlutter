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

                // New Password Field with Visibility Toggle
                TextField(
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color(0xFF113155),  // Custom focused border color
                        width: 2.0,  // Border width
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Confirm Password Field with Visibility Toggle
                TextField(
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Color(0xFF113155),  // Custom focused border color
                        width: 2.0,  // Border width
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Change Password Button with responsive width
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                  height: MediaQuery.of(context).size.height * 0.06, // Responsive height
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement password change logic here
                      _showSuccessDialog();  // Show success dialog when password is changed
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
