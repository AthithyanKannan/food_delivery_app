import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MyButton({super.key,required this.onTap,required this.text});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 120),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8)
        ),
        child: const Center(
          child: Text(
            'Login',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                 fontSize: 16
              )
            ),
        ),
      ),
    );
  }
}