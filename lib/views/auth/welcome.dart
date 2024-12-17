import 'package:flutter/material.dart';
import 'package:medishareflutter/views/auth/login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        // Set background color of Scaffold to transparent if you want to show gradient
        backgroundColor: Colors.transparent,
        body: Container(
          // Apply gradient as the background of the whole page
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFF90CAF9)], // White to Light Blue
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image - Making it responsive
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.1),
                child: Image.asset(
                  'assets/image2.png',
                  height: screenHeight * 0.3, // Adjust image size based on screen height
                  fit: BoxFit.contain, // Ensure the image fits well
                ),
              ),
              // Content box - Responsive size
              Container(
                height: screenHeight * 0.45, // Responsive height
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40.0),
                  ),
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title - Adjust font size based on screen width
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: screenWidth * 0.07, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Description - Adjust font size based on screen width
                    Text(
                      'Discover MediShare: a new way to securely share and collaboratively analyze medical images.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // Responsive font size
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    // Button - Adjust padding and size based on screen size
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.1,
                        ),
                        backgroundColor: const Color(0xFF5289C1), // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Let's Start",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04, // Responsive text size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
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
