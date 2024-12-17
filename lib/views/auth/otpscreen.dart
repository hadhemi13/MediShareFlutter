import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medishareflutter/services/auth_service.dart';
import 'package:medishareflutter/views/auth/changepass.dart';

class OtpConfirmScreen extends StatefulWidget {
  @override
  _OtpConfirmScreenState createState() => _OtpConfirmScreenState();
}

class _OtpConfirmScreenState extends State<OtpConfirmScreen> {
  // List to store the values of OTP fields
  List<String> otp = ["", "", "", "", "", ""];
  final AuthService _authService = AuthService();
  // Error message visibility
  bool showError = false;

  // Function to check if all OTP fields are filled
  bool isOtpComplete() {
    return otp.every((element) => element.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("OTP Confirmation")),
        body: SingleChildScrollView(
          // Wrap content with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  Image.asset(
                    'assets/otp.png',
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    "Enter the OTP sent to your email",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // OTP input fields with dynamic width and height
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: MediaQuery.of(context).size.width * 0.105,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              otp[index] = value;
                            });

                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Show error message if OTP is not complete
                  if (showError)
                    const Text(
                      "Please enter all OTP digits correctly.",
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),

                  // Button to verify OTP
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isOtpComplete()) {
                          final otpCode =
                              "${otp[0]}${otp[1]}${otp[2]}${otp[3]}${otp[4]}${otp[5]}";

                          final response =
                              await _authService.verifyOtp(otpCode);
                          if (response.statusCode == 201) {
                            final Map<String, dynamic> responseData =
                                jsonDecode(response.body);
                            final String resetToken =
                                responseData['resetToken'];

                            // If OTP is complete, navigate to change password screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePasswordScreen(
                                    resetToken: resetToken),
                              ),
                            );
                          }
                        } else {
                          // Show error message if OTP is not complete
                          setState(() {
                            showError = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF90CAF9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Verify OTP",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
