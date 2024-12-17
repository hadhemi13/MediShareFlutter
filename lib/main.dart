import 'package:flutter/material.dart';
import 'package:medishareflutter/services/patient/views/HomePatientMAIN.dart';
import 'package:medishareflutter/viewModels/login_view_model.dart';
import 'package:medishareflutter/viewModels/post_view_model.dart';
import 'package:medishareflutter/viewmodels/clinique_viewmodel.dart';
import 'package:medishareflutter/views/auth/login.dart';
import 'package:medishareflutter/views/radiologue/my_home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter environment is initialized.
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final userRole = prefs.getString('userRole') ?? "no role";
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CliniqueViewModel()),

        ChangeNotifierProvider(create: (_) => LoginViewModel()), // Provide LoginViewModel
        ChangeNotifierProvider(create: (_) => PostViewModel()), // Provide PostViewModel
      ],
      child: MyApp(initialIsLoggedIn: isLoggedIn, userRole: userRole),
    ),
  );
}

/// Main application widget
class MyApp extends StatefulWidget {

  final bool initialIsLoggedIn;
  final String userRole;


  const MyApp({super.key, required this.initialIsLoggedIn, required this.userRole});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
late bool isLoggedIn;
late String userRole;
 @override
  void initState() {
    super.initState();
    isLoggedIn = widget.initialIsLoggedIn;
    userRole = widget.userRole;
  }
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
      home: isLoggedIn
          ? (userRole == "patient" ?const HomeScreenMain1(): userRole == "radiologist"?const MyHomePage():LoginScreen())
          : LoginScreen(),

    );
  }
}
