import 'package:flutter/material.dart';
import 'package:medishareflutter/main.dart';
import 'package:medishareflutter/views/forgotpassword.dart';
import 'package:medishareflutter/views/sendmail.dart';
import 'package:medishareflutter/views/signup.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset:
            true, // Ensures the layout adjusts when the keyboard opens
        body: SingleChildScrollView(
          // Make the body scrollable when keyboard appears
          child: Column(
            children: [
              // Green box with a horizontal wave
              ClipPath(
                clipper: HorizontalWaveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      0.30, // Reduced height from 0.4 to 0.25
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Color(0xFF90CAF9)
                      ], // White to Light Blue
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              // Login form below
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Color(0xFF113155),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: "Identifiant",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFF113155), // Default border color
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFF113155), // Focused border color
                            width: 1, // You can adjust the border width
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "Mot de passe",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFF113155), // Default border color
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFF113155), // Focused border color
                            width: 1, // You can adjust the border width
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF113155),
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .end, // Align the TextButton to the right
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    forgotpassword(), // Replace with your Password Reset screen
                              ),
                            );
                          },
                          child: const Text(
                            "Forgot your password? Reset it",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (bool? value) {}),
                        const Text("Enregistrer mes informations"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Gradient Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .transparent, // Make the background transparent
                        minimumSize: const Size(double.infinity, 50),
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
                          gradient: const LinearGradient(
                            colors: [
                              Color(0x6B90CAF9),
                              Color(0xFF90CAF9)
                            ], // White to Light Blue
                            begin: Alignment
                                .centerLeft, // Start gradient from left
                            end: Alignment.centerRight, // End gradient at right
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "Vous n'avez pas de compte? Créer un compte",
                          style: TextStyle(color: Colors.blue),
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

// Custom clipper for horizontal wave
class HorizontalWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start from the top-left corner
    path.lineTo(0, size.height * 0.85);

    // Create the first wave
    path.quadraticBezierTo(
      size.width * 0.25, size.height, // First control point and end
      size.width * 0.5, size.height * 0.85,
    );

    // Create the second wave
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.7, // Second control point
      size.width, size.height * 0.85,
    );

    // Draw the rest of the path
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
