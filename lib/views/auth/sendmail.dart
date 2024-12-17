import 'package:flutter/material.dart';
import 'package:medishareflutter/views/auth/otpscreen.dart';

class SendMailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Email Sent")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Image with responsive width and height
                Image.asset(
                  'assets/sendmail.png',
                  height: MediaQuery.of(context).size.height * 0.3, // Responsive height
                  width: MediaQuery.of(context).size.width * 0.6,   // Responsive width
                ),

                // Space after image
                const SizedBox(height: 20),

                // Text with center alignment and responsive font size
                const Text(
                  "An email has been sent to your address with OTP code.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),

                // Adjusted space between text and button
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                // Button with responsive width and height
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                  height: MediaQuery.of(context).size.height * 0.06, // 60% of screen width

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OtpConfirmScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF90CAF9), // Set background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.white), // Text color
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
