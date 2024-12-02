import 'package:flutter/material.dart';
import 'package:food_delivery_app/admin/adminpages/list.dart';
import '../components/colors.dart';
import 'adminpages/add.dart';
import 'adminpages/orders.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  // Define the current selected index
  int _currentIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    const Add(),
    const ListPage(), // Replace with your List page
    const Orders(), // Replace with your Orders page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(
          Icons.food_bank,
          size: 30,
          color: Colors.white,
        ),
        automaticallyImplyLeading: false,
        shadowColor: tomoto,
        title: const Text(
          "HungryJi-Admin Panel",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: tomoto,
      ),
      body: _pages[_currentIndex], // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Set the current selected index
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "Add Items",
            icon: Icon(Icons.add),
          ),
          BottomNavigationBarItem(
            label: "List Items",
            icon: Icon(Icons.message),
          ),
          BottomNavigationBarItem(
            label: "Orders",
            icon: Icon(Icons.safety_check),
          ),
        ],
      ),
    );
  }
}
