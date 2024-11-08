import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers to get text from the TextFields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String name = _nameController.text;
    final String password = _passwordController.text;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'password': password,
        }),
      );

      Navigator.of(context).pop(); // Dismiss the loading indicator

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Navigate to the dashboard or show a success message
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()), // Assuming you have a Dashboard widget
        );
      } else {
        // Handle specific error messages if returned
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        _showErrorMessage(errorData['message'] ?? 'Invalid name or password');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Dismiss the loading indicator
      _showErrorMessage('Error logging in. Please try again later.');
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 20; // Smoother, larger border radius

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF477BA6), Color(0xFF123550)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Column(
                      children: [
                        Text(
                          "Welcome Back!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Login to continue",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    // Name Input Field
                    SizedBox(
                      width: 400,
                      child: TextField(
                        controller: _nameController,
                        decoration: _buildInputDecoration(borderRadius, 'Enter Your Name', Icons.person),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Input Field
                    SizedBox(
                      width: 400,
                      child: TextField(
                        controller: _passwordController,
                        decoration: _buildInputDecoration(borderRadius, 'Enter Your Password', Icons.lock),
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login Button
                    SizedBox(
                      width: 400,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _login, // Call the login function
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: const Color(0xFF3B3B3B), // Button color
                        ),
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // Add your forgot password logic here
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(double borderRadius, String hintText, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white70),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Welcome to the Dashboard!"),
      ),
    );
  }
}
