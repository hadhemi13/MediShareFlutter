import 'package:flutter/material.dart';
import 'package:medishareflutter/viewModels/login_view_model.dart';
import 'package:medishareflutter/views/FilesPage.dart';
import 'package:medishareflutter/views/HomePage.dart';
import 'package:medishareflutter/views/ProfileScreen.dart';
import 'package:medishareflutter/views/UploadImage.dart';
import 'package:medishareflutter/views/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter environment is initialized.
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp( ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: MyApp(initialIsLoggedIn: isLoggedIn),
    ),);
}

/// Main application widget
class MyApp extends StatefulWidget  {

  final bool initialIsLoggedIn;


  MyApp({required this.initialIsLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
late bool isLoggedIn;
 @override
  void initState() {
    super.initState();
    isLoggedIn = widget.initialIsLoggedIn;
  }
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
      home: isLoggedIn 
          ? MyHomePage() 
          : LoginScreen(), 
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;



  final List<Widget> _pages = [
    HomePage(),
    const FilesPage(),
    const UploadImage(), // Passe directement updateIndex
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
      body: _pages[_selectedIndex], // Afficher la page sélectionnée
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file),
            label: 'Upload Image',
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