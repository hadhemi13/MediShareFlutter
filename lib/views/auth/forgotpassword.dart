import 'package:flutter/material.dart';
import 'package:medishareflutter/services/auth_service.dart';
import 'package:medishareflutter/views/auth/sendmail.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError; // To store the error message
  final AuthService _authService = AuthService();

  // Function to validate email format
  bool _validateEmail(String email) {
    // Regular expression for validating email format
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Forgot Password"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image and Title Section
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40), // Space after the text
                      Image.asset(
                        'assets/forgot.png', // Path to the image
                        height: MediaQuery.of(context).size.height *
                            0.3, // Responsive height
                        width: MediaQuery.of(context).size.width *
                            0.6, // Responsive width
                      ),
                      const SizedBox(
                          height: 40), // Reduced space before the text
                      const Text(
                        "Enter your email to reset your password",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40), // Space after the text

                // Email Input Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText:
                        "Email", // Placeholder text when the field is empty
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                      borderSide: BorderSide(
                        color: Color(0xFF113155), // Default border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30), // Rounded corners for focused state
                      borderSide: BorderSide(
                        color: Color(0xFF113155), // Focused border color
                        width: 1, // Border width when focused
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30), // Same rounded corners for enabled state
                      borderSide: BorderSide(
                        color: Color(0xFF113155), // Border color when enabled
                        width: 1, // Border width when enabled
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30), // Rounded corners for error state
                      borderSide: BorderSide(
                        color: Color(0xFF113155), // Error border color
                        width: 1, // Border width when error
                      ),
                    ),
                  ),
                  // Handle the validation error text display
                ),
                const SizedBox(height: 20), // Space after the text

                if (_emailError != null)
                  Center(
                    child: Text(
                      _emailError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 40), // Space after the text

                // Send Reset Link Button
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.8, // 80% of screen width
                    height: MediaQuery.of(context).size.height *
                        0.06, // Responsive height
                    child: ElevatedButton(
                      onPressed: () async {
                        // Validate email
                        if (_validateEmail(_emailController.text)) {
                          final response = await _authService
                              .forgotPassword(_emailController.text);
                          if (response.statusCode == 201) {
                            setState(() {
                              _emailError = null; // Clear any previous error
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SendMailScreen()),
                            );
                          }
                        } else {
                          setState(() {
                            _emailError =
                                'Please enter a valid email address'; // Show error
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF90CAF9), // Set background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Keep rounded corners
                        ),
                      ),
                      child: const Text(
                        "Send Mail",
                        style: TextStyle(color: Colors.white), // Text color
                      ),
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
