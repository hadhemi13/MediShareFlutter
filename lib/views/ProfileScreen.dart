import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/backgroundprof.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Profile Card
                  Positioned(
                    top: 160,
                    left: 16,
                    right: 16,
                    child: Card(
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child:const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Profile Image
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xF9F9F9F9),
                              backgroundImage: AssetImage('assets/profile.png'),
                            ),
                             SizedBox(width: 16),
                            // Profile Name and Email
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Guest',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Guest@esprit.tn',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'You can update your profile here.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildOptionCard(
                      context,
                      icon: Icons.dark_mode,
                      title: 'Dark mode',
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildOptionCard(
                      context,
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    const SizedBox(height: 8),
                    _buildOptionCard(
                      context,
                      icon: Icons.lock,
                      title: 'Change Password',
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    const SizedBox(height: 8),
                    _buildOptionCard(
                      context,
                      icon: Icons.logout,
                      title: 'Logout',
                      trailing: const Icon(Icons.arrow_forward_ios),
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

  Widget _buildOptionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget trailing,
      }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700]),
        title: Text(title),
        trailing: trailing,
      ),
    );
  }
}

