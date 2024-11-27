import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/my_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen background image with opacity
          // Positioned.fill(
          //   child: Opacity(
          //     opacity: 0.83,
          //     child: Image.asset(
          //       "assets/images/header_img.png",
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
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
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns text to the start
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
                      controller: name, hintText: "Name", obscureText: false),
                  const SizedBox(height: 20),
                  MyTextField(
                      controller: email, hintText: "Email", obscureText: false),
                  const SizedBox(height: 20),
                  MyTextField(
                      controller: pass,
                      hintText: "Password",
                      obscureText: true),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Create Account",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 50)),
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xF9F59584)),
                        shape: WidgetStateProperty.all(BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(4)))),
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