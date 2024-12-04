import 'dart:math';

import 'package:flutter/material.dart';
import 'package:medishareflutter/views/confirmmail.dart';
import 'package:medishareflutter/views/login.dart';
import 'package:medishareflutter/views/terms.dart';
import 'package:path/path.dart';  // Import login screen for navigation

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool isTermsChecked = false;
  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isConfirmPasswordValid = true;
  bool isUsernameValid = true;
  final TextEditingController userNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();


  String generatedPassword = '';
  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';
  String usernameError = '';

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

  void _openTermsAndConditions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TermsAndConditionsPage(onAccept: () {
        // Once terms are accepted, check the checkbox
        setState(() {
          isTermsChecked = true;
        });
      })),
    );
  }
  void validateInput() {
    setState(() {
      // Reset error messages
      isEmailValid = true;
      isPasswordValid = true;
      isConfirmPasswordValid = true;
      isUsernameValid = true;

      emailError = '';
      passwordError = '';
      confirmPasswordError = '';
      usernameError = '';

      // Email validation
      if (emailController.text.isEmpty) {
        isEmailValid = false;
        emailError = 'Email is required.';
      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
        isEmailValid = false;
        emailError = 'Please enter a valid email address: example@example.com';
      }

      // Username validation
      if (userNameController.text.isEmpty) {
        isUsernameValid = false;
        usernameError = 'Username is required.';
      } else if (userNameController.text.length < 4) {
        isUsernameValid = false;
        usernameError = 'Username must be at least 4 characters long.';
      }

      // Password validation
      if (passwordController.text.isEmpty) {
        isPasswordValid = false;
        passwordError = 'Password is required.';
      } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])').hasMatch(passwordController.text)) {
        isPasswordValid = false;
        passwordError = 'Password must contain an uppercase letter, a lowercase letter, a digit, and a special character.';
      } else if (passwordController.text.length < 6) {
        isPasswordValid = false;
        passwordError = 'Password must be at least 6 characters long.';
      }

      // Confirm password validation
      if (confirmPasswordController.text != passwordController.text) {
        isConfirmPasswordValid = false;
        confirmPasswordError = 'Passwords do not match.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,  // Ensures the layout adjusts when the keyboard opens
        body: SingleChildScrollView(  // Make the body scrollable when keyboard appears
          child: Column(
            children: [
              // Green box with a horizontal wave
              ClipPath(
      
                clipper: HorizontalWaveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.30,  // Reduced height from 0.4 to 0.25
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFF90CAF9)], // White to Light Blue
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo.png', // Path to your image
                          height: 100, // Adjust the size as needed
                          width: 100,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              // Sign up form below
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color(0xFF113155),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: userNameController,
      
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "User Name",
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
                      ),
                    ),
                    if (!isUsernameValid)
                      Text(
                        usernameError,
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: "Email",
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
                      ),
                    ),
                    if (!isEmailValid)
                      Text(
                        emailError,
                        style: TextStyle(color: Colors.red),
                      ),
      
                    SizedBox(height: 20),
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
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: isTermsChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isTermsChecked = value ?? false;
                            });
      
                            // If checkbox is checked, open Terms and Conditions page
                            if (isTermsChecked) {
                              _openTermsAndConditions(context);
                            }
                          },
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return const Color(0xFF90CAF9); // Background color when checked
                              }
                              return Colors.transparent; // Background color when unchecked
                            },
                          ),
                        ),
                        Text("Accept terms & conditions"),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Gradient Button
                    ElevatedButton(
                      onPressed: () {
                        // First, check if the terms are checked
                        if (isTermsChecked) {
                          // Call the validation function
                          validateInput();
      
                          // If the validation passes, proceed to the login screen
                          if (isEmailValid && isPasswordValid && isConfirmPasswordValid && isUsernameValid) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => confirmMailScreen()),
                            );
                          }
                        } else {
                          // Show an error message if terms are not checked
                          // You could display a Snackbar, alert dialog, or other method to notify the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("You must agree to the terms and conditions."),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Make the background transparent
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: BorderSide.none, // Optional: Remove any border
                      ).copyWith(
                        // Applying gradient to the button
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                        shadowColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0x9990CAF9),
                              Color(0xFF90CAF9)
                            ], // White to Light Blue
                            begin: Alignment.centerLeft,  // Start gradient from left
                            end: Alignment.centerRight,   // End gradient at right
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          child: Text(
                            "Signup",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          "Vous avez déjà un compte? Se connecter",
                          style: TextStyle(color: Color(0xFF113155)),
                        ),
                      ),
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
}
class HorizontalWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start from the top-left corner
    path.moveTo(0, 0);

    // Draw a straight line to the top-right corner
    path.lineTo(size.width, 0);

    // Move to the bottom-right corner
    path.lineTo(size.width, size.height * 0.85);

    // Create the first wave (right to middle)
    path.quadraticBezierTo(
      size.width * 0.75, size.height,         // Control point
      size.width * 0.5, size.height * 0.85,   // End of first wave
    );

    // Create the second wave (middle to left)
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.7,   // Control point
      0, size.height * 0.85,                 // End of second wave
    );

    // Close the path by returning to the starting point at the top-left corner
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
