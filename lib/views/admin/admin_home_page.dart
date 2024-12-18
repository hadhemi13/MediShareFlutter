import 'package:flutter/material.dart';
import 'package:medishareflutter/views/admin/map_screen.dart';
import 'package:medishareflutter/views/admin/users_screen.dart';
import 'package:medishareflutter/views/admin/clinics_screen.dart'; // Import the Clinics screen
import 'package:medishareflutter/views/auth/ProfileScreen.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  // Add ClinicsScreen to the pages list
  final List<Widget> _pages = [
    MapScreen(),
    UsersScreen(),
    ClinicsScreen(), // Add the Clinics page
    const ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital), // Use an icon for Clinics
            label: 'Clinics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
