import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: tomoto)),
            fillColor: Colors.white,
            filled: true,
            hintText: widget.hintText,
            
            hintStyle: GoogleFonts.outfit(
              color: Colors.black
            )
            ),
      ),
    );
  }
}
