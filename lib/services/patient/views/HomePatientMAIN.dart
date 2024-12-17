import 'package:flutter/material.dart';
import 'package:medishareflutter/services/patient/views/AllrecommandationPatient.dart';
import 'package:medishareflutter/services/patient/views/HomePatient.dart';
import 'package:medishareflutter/services/patient/views/ListImagePatient.dart';
import 'package:medishareflutter/services/patient/views/uploadImagePatient.dart';
import 'package:medishareflutter/views/auth/ProfileScreen.dart';

class HomeScreenMain1 extends StatefulWidget {
 const HomeScreenMain1({Key? key}) : super(key: key);
 


  @override
  State<HomeScreenMain1> createState() => _HomeScreenMain1State();
}

class _HomeScreenMain1State extends State<HomeScreenMain1> {
  int _selectedIndex = 0;

  // Method to return the current screen dynamically
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return MyHomePagePatient();
      case 1:
        return ImageListScreen1(key: UniqueKey()); // Force rebuild
      case 2:
        return UploadAndAnalyzeScreen();
      case 3:
        return RecommendationsScreen();
      case 4:
        return ProfileView();
      default:
        return MyHomePagePatient();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedIndex), // Dynamically load the screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: "Folder",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit_rounded),
            label: "Recommandations",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
