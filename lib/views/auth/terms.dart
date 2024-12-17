import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  final VoidCallback onAccept; // Callback for accepting terms

  TermsAndConditionsPage({required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Terms and Conditions'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x9990CAF9), Color(0xFF90CAF9)], // White to Light Blue
                begin: Alignment.centerLeft, // Start gradient from left
                end: Alignment.centerRight,   // End gradient at right
              ),
            ),
          ),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Terms and Conditions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '1. Introduction\n\n'
                    'Welcome to MediShare, a mobile application developed by DreamCrafters. By accessing or using MediShare, you agree to comply with these Terms and Conditions. If you do not agree, please refrain from using the app.\n\n'
                    '2. Eligibility\n\n'
                    'MediShare is designed for healthcare professionals, patients, and clinics. You must be at least 18 years old to use the app. By registering, you confirm the accuracy of the information provided.\n\n'
                    '3. Usage of Services\n\n'
                    'For Healthcare Professionals: You may share, analyze, and discuss medical images, as well as provide interpretations.\n'
                    'For Patients: You can manage your medical records, receive diagnostic results, and access personalized recommendations.\n'
                    'For Clinics: Authentication and management of institutional data are mandatory.\n\n'
                    '4. Prohibited Activities\n\n'
                    'You agree not to:\n'
                    '- Share content that violates privacy laws or ethical standards.\n'
                    '- Use the app for unauthorized purposes or distribute harmful software.\n'
                    '- Misrepresent your identity or qualifications.\n\n'
                    '5. Intellectual Property\n\n'
                    'All content within MediShare, including AI tools, designs, and features, is the property of DreamCrafters. Unauthorized use is prohibited.\n\n'
                    '6. Disclaimer\n\n'
                    'MediShare provides tools to facilitate decision-making but does not replace professional medical advice. Users are responsible for the accuracy and interpretation of shared data.\n\n'
                    '7. Termination\n\n'
                    'We reserve the right to terminate accounts violating these terms without prior notice.\n\n'
                    '8. Limitation of Liability\n\n'
                    'DreamCrafters is not liable for any damages resulting from misuse of the app or inaccuracies in user-generated content.\n\n'
              ),
          Text(
          'Privacy Policy\n',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
              Text(
                    '1. Information We Collect\n\n'
                    '- Personal Information: Names, contact details, and professional qualifications for healthcare professionals.\n'
                    '- Medical Data: Images and associated metadata uploaded by users.\n'
                    '- Usage Data: Logs and analytics to improve app performance.\n\n'
                    '2. How We Use Information\n\n'
                    '- Provide Services: Facilitate sharing, analysis, and discussion of medical images.\n'
                    '- AI Enhancements: Use anonymized data for algorithm improvement.\n'
                    '- User Support: Address technical issues and queries.\n\n'
                    '3. Data Security\n\n'
                    'MediShare employs encryption, secure storage, and access control to protect your data. We cannot guarantee absolute security but strive to implement industry-standard measures.\n\n'
                    '4. Data Sharing\n\n'
                    'We do not sell or share personal information with third parties except:\n'
                    '- When required by law.\n'
                    '- To comply with medical regulations.\n'
                    '- For app improvements, using anonymized data.\n\n'
                    '5. User Rights\n\n'
                    '- Access and Control: Users can view and update their data.\n'
                    '- Deletion: Request deletion of accounts and associated data.\n\n'
                    '6. Cookies and Tracking\n\n'
                    'The app uses cookies and similar technologies for analytics and personalized user experience.\n\n'
                    '7. Third-Party Services\n\n'
                    'MediShare may link to external tools or services, each governed by its privacy policies.\n\n'
                    '8. Changes to the Policy\n\n'
                    'DreamCrafters reserves the right to modify this Privacy Policy. Users will be notified of significant changes.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    onAccept(); // Invoke the callback when the user accepts
                    Navigator.pop(context); // Close the terms page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Transparent background
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                    ),
                    side: BorderSide.none, // Remove border
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0x9990CAF9), Color(0xFF90CAF9)], // Gradient from White to Light Blue
                        begin: Alignment.centerLeft, // Start gradient from left
                        end: Alignment.centerRight,   // End gradient at right
                      ),
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Text(
                        "Accept and Continue", // Text for the button
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
