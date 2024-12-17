
import 'package:flutter/material.dart';
import 'package:medishareflutter/services/patient/views/AllrecommandationPatient.dart';
import 'package:medishareflutter/services/patient/views/HomePatient.dart';
import 'package:medishareflutter/services/patient/views/ListImagePatient.dart';
import 'package:medishareflutter/services/patient/views/uploadImagePatient.dart';
import 'package:medishareflutter/views/auth/ProfileScreen.dart';

class HomeScreenMain1 extends StatefulWidget {
 const HomeScreenMain1({Key? key}) : super(key: key);
 

  @override
  State<HomeScreenMain1> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenMain1> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [

    MyHomePagePatient(),
    ImageListScreen1(),
    UploadAndAnalyzeScreen(),
    RecommendationsScreen(),
    ProfileView()
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
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