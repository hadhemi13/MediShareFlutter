import 'package:flutter/material.dart';
import 'package:medishareflutter/views/changepass.dart';

class OtpConfirmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("OTP Confirmation")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(

              children: [
                const SizedBox(height: 30), // Adjusted space between image and text

                // Image with responsive height and width
                Image.asset(
                  'assets/otp.png', // Path to the image
                  height: MediaQuery.of(context).size.height * 0.3, // Responsive height
                  width: MediaQuery.of(context).size.width * 0.6,   // Responsive width
                ),
                const SizedBox(height: 30), // Adjusted space between image and text

                // Text with center alignment and responsive font size
                const Text(
                  "Enter the OTP sent to your email",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40), // Adjusted space between text and OTP fields

                // OTP input fields with dynamic width and height
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8), // Increase horizontal margin to create space
                      width: MediaQuery.of(context).size.width * 0.105, // 10% of screen width
                      height: MediaQuery.of(context).size.height * 0.05, // 6% of screen height
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1, // Limit to one character
                        decoration: InputDecoration(
                          counterText: "", // Hides the counter
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            // Automatically move to the next field
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            // Move to the previous field if the current is empty
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40), // Adjusted space before the button

                // Button with responsive width and height
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                  height: MediaQuery.of(context).size.height * 0.06, // 6% of screen height
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF90CAF9), // Set background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                    child: const Text(
                      "Verify OTP",
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
