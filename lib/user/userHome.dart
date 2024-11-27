// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:food_delivery_app/user/CartPage.dart';
// import 'package:food_delivery_app/user/userOrders.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class UserHome extends StatefulWidget {
//   const UserHome({super.key});

//   @override
//   _UserHomeState createState() => _UserHomeState();
// }

// class _UserHomeState extends State<UserHome> {
//   List<dynamic> foodItems = [];
//   List<dynamic> cartItems = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchFoodItems();
//   }

//   Future<void> fetchFoodItems() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');

//       final response = await http.get(
//         Uri.parse("http://10.10.66.71:4000/api/food/list"),
//         headers: {'token': token ?? ''},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success']) {
//           setState(() {
//             foodItems = data['data'];
//             isLoading = false;
//           });
//         } else {
//           throw Exception("Failed to fetch data");
//         }
//       } else {
//         throw Exception("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print("Error: $e");
//     }
//   }

//   void addToCart(dynamic food) {
//     setState(() {
//       cartItems.add(food);
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("${food['name']} added to cart!")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Food Cart"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.shopping_cart),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CartPage(cartItems: cartItems),
//                 ),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.notification_add_rounded),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => UserOrdersPage(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : foodItems.isEmpty
//               ? const Center(child: Text("No food items found."))
//               : ListView.builder(
//                   itemCount: foodItems.length,
//                   itemBuilder: (context, index) {
//                     final food = foodItems[index];
//                     return Card(
//                       margin: const EdgeInsets.all(8.0),
//                       child: ListTile(
//                         title: Text(food['name'] ?? "Unnamed Food"),
//                         subtitle: Text(
//                           "${food['description']}\nCategory: ${food['category']}",
//                         ),
//                         trailing: Column(
//                           children: [
//                             Text("\$${food['price']}"),
//                             IconButton(
//                               icon: const Icon(Icons.add_shopping_cart),
//                               onPressed: () => addToCart(food),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }
