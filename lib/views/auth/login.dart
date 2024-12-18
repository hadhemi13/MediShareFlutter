/*import 'package:flutter/material.dart';
import 'package:medishareflutter/main.dart';
import 'package:medishareflutter/services/patient/views/HomePatient.dart';
import 'package:medishareflutter/services/patient/views/HomePatientMAIN.dart';
import 'package:medishareflutter/viewModels/login_view_model.dart';
import 'package:medishareflutter/views/admin/admin_home_page.dart';
import 'package:medishareflutter/views/auth/forgotpassword.dart';
import 'package:medishareflutter/views/auth/signup.dart';
import 'package:medishareflutter/views/radiologue/my_home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isRememberMeChecked = false;
  bool isEmailValid = true;
  bool isPasswordValid = true;

  String emailError = '';
  String passwordError = '';

  void validateInput() {
    setState(() {
      // Reset error messages
      isEmailValid = true;
      isPasswordValid = true;
      emailError = '';
      passwordError = '';

      // Email validation
      if (emailController.text.isEmpty) {
        isEmailValid = false;
        emailError = 'The Email is required.';
      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
          .hasMatch(emailController.text)) {
        isEmailValid = false;
        emailError = 'Please enter a valid email address : exemple@exemple.com';
      }

      // Password validation
      if (passwordController.text.isEmpty) {
        isPasswordValid = false;
        passwordError = 'The Password is required.';
      }
    });
  }

  InputDecoration buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(
        prefixIcon,
        color: const Color(0xFF113155), // Default color for the icon
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF113155), // Default hint text color
        fontSize: 14, // Smaller font size for hint text
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Color(0xFF113155), // Focused border color
          width: 1,
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Adjust layout when the keyboard opens
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header with a wave and logo
              ClipPath(
                clipper: HorizontalWaveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFF90CAF9)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/logo.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ),
              // Login Form
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Color(0xFF113155),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: buildInputDecoration(
                        hintText: "Email",
                        prefixIcon: Icons.person,
                      ),
                    ),
                    if (!isEmailValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 15),
                        child: Text(
                          emailError,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: buildInputDecoration(
                        hintText: "Password",
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF113155),
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    if (!isPasswordValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 15),
                        child: Text(
                          passwordError,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forgot your password ? Reset it",
                            style: TextStyle(color: Color(0xFF113155)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isRememberMeChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isRememberMeChecked = value ?? true;
                            });
                          },
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return const Color(
                                    0xFF90CAF9); // Background color when checked
                              }
                              return Colors
                                  .transparent; // Background color when unchecked
                            },
                          ),
                        ),
                        const Text("Remember me "),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        validateInput();
                        if (isEmailValid && isPasswordValid) {
                          try {
                            final loginViewModel =
                                context.read<LoginViewModel>();
                            bool success = await loginViewModel.login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                            if (success) {
                                 final prefs = await SharedPreferences.getInstance();

                                  var userRole =  await prefs.getString('userRole');
                                if(userRole == "radiologist")
                                {

                                    Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyHomePage()),
                                (route) => false,
                              );
                                }
                                else if (userRole == "patient")
                                {
                                    Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreenMain1()),
                                (route) => false,
                              );

                                } else 
                                {
                                   Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminHomePage()),
                                (route) => false,
                              );
                                }
                                


                            
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Login Failed'),
                                    content: Text(loginViewModel.errorMessage ??
                                        'Unknown error'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } catch (error) {
                            print(
                                "___________________________________________");
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0x9990CAF9), Color(0xFF90CAF9)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "You don't have an account ? Create One",
                          style: TextStyle(color: Color(0xFF113155)),
                        ),
                      ),
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
}

// Custom clipper for the header wave
class HorizontalWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height * 0.85);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.85,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.85,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
*/
import 'package:flutter/material.dart';
import 'package:medishareflutter/services/patient/views/HomePatient.dart';
import 'package:medishareflutter/services/patient/views/HomePatientMAIN.dart';
import 'package:medishareflutter/viewModels/login_view_model.dart';
import 'package:medishareflutter/views/admin/admin_home_page.dart';
import 'package:medishareflutter/views/auth/forgotpassword.dart';
import 'package:medishareflutter/views/auth/signup.dart';
import 'package:medishareflutter/views/radiologue/my_home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isRememberMeChecked = false;
  bool isEmailValid = true;
  bool isPasswordValid = true;

  String emailError = '';
  String passwordError = '';

  void validateInput() {
    setState(() {
      // Reset error messages
      isEmailValid = true;
      isPasswordValid = true;
      emailError = '';
      passwordError = '';

      // Email validation
      if (emailController.text.isEmpty) {
        isEmailValid = false;
        emailError = 'The Email is required.';
      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
        isEmailValid = false;
        emailError = 'Please enter a valid email address: example@exemple.com';
      }

      // Password validation
      if (passwordController.text.isEmpty) {
        isPasswordValid = false;
        passwordError = 'The Password is required.';
      }
    });
  }

  InputDecoration buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(
        prefixIcon,
        color: const Color(0xFF113155), // Default color for the icon
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF113155), // Default hint text color
        fontSize: 14, // Smaller font size for hint text
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: Color(0xFF113155), // Focused border color
          width: 1,
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }

  // Function to show the custom 401 Unauthorized dialog
  void showUnauthorizedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Banned Account'),
          content: Text('You can\'t access as a radiologist your mail must be confirmed by the admin '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Adjust layout when the keyboard opens
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header with a wave and logo
              ClipPath(
                clipper: HorizontalWaveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFF90CAF9)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/logo.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ),
              // Login Form
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Color(0xFF113155),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: buildInputDecoration(
                        hintText: "Email",
                        prefixIcon: Icons.person,
                      ),
                    ),
                    if (!isEmailValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 15),
                        child: Text(
                          emailError,
                          style:
                          const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: buildInputDecoration(
                        hintText: "Password",
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF113155),
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    if (!isPasswordValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 15),
                        child: Text(
                          passwordError,
                          style:
                          const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forgot your password? Reset it",
                            style: TextStyle(color: Color(0xFF113155)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isRememberMeChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isRememberMeChecked = value ?? true;
                            });
                          },
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return const Color(0xFF90CAF9); // Background color when checked
                              }
                              return Colors.transparent; // Background color when unchecked
                            },
                          ),
                        ),
                        const Text("Remember me "),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        validateInput();
                        if (isEmailValid && isPasswordValid) {
                          try {
                            final loginViewModel =
                            context.read<LoginViewModel>();
                            bool success = await loginViewModel.login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                            if (success) {
                              final prefs = await SharedPreferences.getInstance();
                              var userRole = await prefs.getString('userRole');
                              if (userRole == "radiologist") {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyHomePage()),
                                      (route) => false,
                                );
                              } else if (userRole == "patient") {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreenMain1()),
                                      (route) => false,
                                );
                              } else {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminHomePage()),
                                      (route) => false,
                                );
                              }
                            } else {
                              showUnauthorizedDialog(); // Show the 401 dialog
                            }
                          } catch (error) {
                            print("Error: $error");
                            if (error.toString().contains("401")) {
                              showUnauthorizedDialog(); // Show the 401 dialog
                            }
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0x9990CAF9), Color(0xFF90CAF9)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "You don't have an account? Create One",
                          style: TextStyle(color: Color(0xFF113155)),
                        ),
                      ),
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
}

// Custom clipper for the header wave
class HorizontalWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height * 0.85);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.85,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.85,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
