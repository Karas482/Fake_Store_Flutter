import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const UserProfile());
}

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _userFormController = TextEditingController();
  final _emailFormController = TextEditingController();
  final _passwordFormController = TextEditingController();
  bool _isEditing = false; // Track if the form is in edit mode
  String apiUrl = 'http://127.0.0.1:5000/userProfile';  // Replace with your actual API URL
  String username = "";
  String email = "";
  String password = "";

  @override
  void dispose() {
    _userFormController.dispose();
    _emailFormController.dispose();
    _passwordFormController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile(); // Fetch user profile data when the app starts
  }

  // Function to fetch user profile data
  Future<void> fetchUserProfile() async {
    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          username = data['username'];
          email = data['email'];
          password = data['password']; // For demo purposes, avoid storing plain-text passwords
          _userFormController.text = username;
          _emailFormController.text = email;
          _passwordFormController.text = password;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load profile")),
        );
      }
    } catch (error) {
      print("Error fetching profile: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error connecting to server")),
      );
    }
  }

  // Function to submit edited user data to the API
  Future<void> submitProfile() async {
    String newUsername = _userFormController.text;
    String newEmail = _emailFormController.text;
    String newPassword = _passwordFormController.text;

    if (newUsername.isEmpty || newEmail.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      var response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": newUsername,
          "email": newEmail,
          "password": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          username = newUsername;
          email = newEmail;
          password = newPassword;
          _isEditing = false; // Stop editing after successful submission
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile")),
        );
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error connecting to server")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.person),
          title: const Text("View/Edit Profile"),
          actions: [
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              onPressed: () {
                if (_isEditing) {
                  submitProfile();
                } else {
                  setState(() {
                    _isEditing = true; // Enable edit mode
                  });
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: _userFormController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: const OutlineInputBorder(),
                  ),
                  enabled: _isEditing, // Enable editing if in edit mode
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailFormController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: const OutlineInputBorder(),
                  ),
                  enabled: _isEditing, // Enable editing if in edit mode
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordFormController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                  ),
                  obscureText: true,
                  enabled: _isEditing, // Enable editing if in edit mode
                ),
                const SizedBox(height: 20),
                if (!_isEditing)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = true; // Enable edit mode when 'Edit' is pressed
                      });
                    },
                    child: const Text("Edit Profile"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
