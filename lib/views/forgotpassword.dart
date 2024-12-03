import 'package:flutter/material.dart';
import 'package:medishareflutter/views/sendmail.dart';

class forgotpassword extends StatelessWidget {
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
                        height: MediaQuery.of(context).size.height * 0.3, // Responsive height
                        width: MediaQuery.of(context).size.width * 0.6,   // Responsive width
                      ),
                      const SizedBox(height: 40), // Reduced space before the text
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
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Space after the text

                // Send Reset Link Button
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                    height: MediaQuery.of(context).size.height * 0.06, // Responsive height
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SendMailScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF90CAF9), // Set background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Keep rounded corners
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
