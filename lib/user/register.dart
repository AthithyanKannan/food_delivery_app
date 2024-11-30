import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/my_text_field.dart';
import 'package:food_delivery_app/user/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _name = TextEditingController();

  Future<void> registerUser() async {
    const String url = "http://10.10.71.160:4000/api/user/register";

    final Map<String, String> data = {
      'name': _name.text,
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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseData['token']);

          toastification.show(
            context: context,
            title: Text("Success"),
            description: Text("Registration successful!"),
            backgroundColor: Colors.green,
          );

          Navigator.pushReplacement(
             context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        } else {
          toastification.show(
            context: context,
            title: const Text("Error"),
            description: responseData['message'],
            backgroundColor: Colors.red,
          );
        }
      } else {
        toastification.show(
          context: context,
          title: const Text("Error"),
          description: const Text("Error during registrations"),
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text("Error"),
        description: Text("Error : $e"),
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              "Register Now",
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
                      controller: _name, hintText: "Name", obscureText: false),
                  const SizedBox(height: 20),
                  MyTextField(
                      controller: _email, hintText: "Email", obscureText: false),
                  const SizedBox(height: 20),
                  MyTextField(
                      controller: _pass,
                      hintText: "Password",
                      obscureText: true),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: registerUser,
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(horizontal: 50)),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xF9F59584)),
                        shape: MaterialStateProperty.all(BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(4)))),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
