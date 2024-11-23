import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_delivery_app/user/userHome.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/components/my_text_field.dart';
import 'package:food_delivery_app/components/my_button.dart';
import 'package:food_delivery_app/user/userRegister.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

Future<void> login() async {
  const String url = "http://10.10.66.71:4000/api/user/login";

  final Map<String, String> data = {
    'email': email.text,
    'password': password.text,
  };

  final headers = {'Content-Type': 'application/json'};

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['success']) {
        final String? token = responseData['token'];

        if (token != null) {
          // Decode the JWT to extract the userId
          final parts = token.split('.');
          if (parts.length == 3) {
            final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
            final payloadMap = jsonDecode(payload);
            final String? userId = payloadMap['id'];

            if (userId != null) {
              // Save token and userId in SharedPreferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', token);
              await prefs.setString('userId', userId);

              Fluttertoast.showToast(msg: "Login successful!");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const UserHome()),
              );
            } else {
              Fluttertoast.showToast(msg: "User ID not found in token.");
            }
          } else {
            Fluttertoast.showToast(msg: "Invalid token structure.");
          }
        } else {
          Fluttertoast.showToast(msg: "Token not provided in response.");
        }
      } else {
        Fluttertoast.showToast(msg: "Incorrect Email or Password");
      }
    } else {
      Fluttertoast.showToast(msg: "Error during login. Server responded with status code: ${response.statusCode}");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error: $e");
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 100),
              const SizedBox(height: 40),
              Text(
                "Welcome back you've been missed",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: email,
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: password,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 10),
              MyButton(onTap: login, text: "Login"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
