import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/colors.dart';
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
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  Future<void> login() async {
    const String url = "http://10.10.64.116:4000/user/login";

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
            final parts = token.split('.');
            if (parts.length == 3) {
              final payload =
                  utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
              final payloadMap = jsonDecode(payload);
              final String? userId = payloadMap['id'];

              if (userId != null) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('token', token);
                await prefs.setString('userId', userId);

                if (mounted) {
                  toastification.show(
                    context: context,
                    title: const Text("Success"),
                    description: const Text("Login successful"),
                    backgroundColor: Colors.green,
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                }
              } else {
                if (mounted) {
                  toastification.show(
                    context: context,
                    title: const Text("Error"),
                    description: const Text("User ID not found in token."),
                    backgroundColor: Colors.red,
                  );
                }
              }
            } else {
              if (mounted) {
                toastification.show(
                  context: context,
                  title: const Text("Error"),
                  description: const Text("Invalid token structure."),
                  backgroundColor: Colors.red,
                );
              }
            }
          } else {
            if (mounted) {
              toastification.show(
                context: context,
                title: const Text("Error"),
                description: const Text("Token not provided in response."),
                backgroundColor: Colors.red,
              );
            }
          }
        } else {
          if (mounted) {
            toastification.show(
              context: context,
              title: const Text("Error"),
              description: const Text("Incorrect Email or Password"),
              backgroundColor: Colors.red,
            );
          }
        }
      } else {
        if (mounted) {
          toastification.show(
            context: context,
            title: const Text("Error"),
            description: Text(
                "Error during login. Server responded with status code: ${response.statusCode}"),
            backgroundColor: Colors.red,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          context: context,
          title: const Text("Error"),
          description: Text("Error: $e"),
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
                                    color: tomoto),
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
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 50)),
                            backgroundColor: WidgetStateProperty.all(tomoto),
                            shape: WidgetStateProperty.all(
                                BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)))),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        )),
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
                            style: TextStyle(color: tomoto),
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
