import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/my_button.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/user/userHome.dart'; // Import your home page

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Register User Function
  Future<void> registerUser() async {
    const String url = "http://10.10.69.244:4000/api/user/register"; // Change to your backend API URL

    final Map<String, String> data = {
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data), // Send data as JSON
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success']) {
          Fluttertoast.showToast(msg: "Registration successful!");
          
          // Navigate to the home page or another screen after successful registration
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserHome()),
          );
        } else {
          Fluttertoast.showToast(msg: responseData['message']);
        }
      } else {
        Fluttertoast.showToast(msg: "Error during registration.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            MyButton(
              onTap: () {
                if (_nameController.text.isEmpty ||
                    _emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Please fill in all fields.");
                } else {
                  registerUser();
                }
              },
              text: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}