import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/my_text_field.dart';
import 'package:food_delivery_app/user/home.dart';
import 'package:food_delivery_app/user/register.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();

  Future<void> login() async {
    const String url = "http://10.10.68.154:4000/api/user/login";

    final Map<String, String> data = {
      'email': _email.text,
      'password': _pass.text,
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
              final payload =
                  utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
              final payloadMap = jsonDecode(payload);
              final String? userId = payloadMap['id'];

              if (userId != null) {
                // Save token and userId in SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('token', token);
                await prefs.setString('userId', userId);

                toastification.show(
                  context: context,
                  title: Text("Success"),
                  description: Text("Login successful"),
                  backgroundColor: Colors.green,
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              } else {
                toastification.show(
                  context: context,
                  title: Text("Error"),
                  description: Text("User ID not found in token."),
                  backgroundColor: Colors.red,
                );
              }
            } else {
              toastification.show(
                context: context,
                title: Text("Error"),
                description: Text("Invalid token structure."),
                backgroundColor: Colors.red,
              );
            }
          } else {
            toastification.show(
              context: context,
              title: Text("Error"),
              description: Text("Token not provided in response."),
              backgroundColor: Colors.red,
            );
          }
        } else {
          toastification.show(
            context: context,
            title: Text("Error"),
            description: Text("Incorrect Email or Password"),
            backgroundColor: Colors.red,
          );
        }
      } else {
        toastification.show(
          context: context,
          title: Text("Error"),
          description:
              Text("Error during login. Server responded with status code: ${response.statusCode}"),
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      toastification.show(
        context: context,
          title: Text("Error"),
        description: Text("Error: $e"),
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.width * 1.2,
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Login",
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Welcome back! Login to continue your food journey and enjoy fast, fresh, and delicious meals delivered to you.",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    MyTextField(
                        controller: _email,
                        hintText: "Email",
                        obscureText: false),
                    const SizedBox(height: 20),
                    MyTextField(
                        controller: _pass,
                        hintText: "Password",
                        obscureText: true),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: login,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(horizontal: 50),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                            const Color(0xF9F59584)),
                        shape: MaterialStateProperty.all(BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        )),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Register(),
                              ),
                            );
                          },
                          child: const Text(
                            "Register Now",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
