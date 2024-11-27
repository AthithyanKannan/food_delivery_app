// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class UserOrdersPage extends StatefulWidget {
//   const UserOrdersPage({super.key});

//   @override
//   _UserOrdersPageState createState() => _UserOrdersPageState();
// }

// class _UserOrdersPageState extends State<UserOrdersPage> {
//   List<dynamic> orders = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchOrders();
//   }

//   Future<void> fetchOrders() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('token');

//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("You are not logged in.")),
//         );
//         return;
//       }

//       final response = await http.post(
//         Uri.parse("http://10.10.66.71:4000/api/order/userorders"), // Replace with your API endpoint
//         headers: {
//           "Content-Type": "application/json",
//           "token": token,
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success']) {
//           setState(() {
//             orders = data['data'];
//             isLoading = false;
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Failed to fetch orders.")),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: ${response.statusCode}")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("An error occurred: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Your Orders"),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : orders.isEmpty
//               ? const Center(child: Text("No orders found."))
//               : ListView.builder(
//                   itemCount: orders.length,
//                   itemBuilder: (context, index) {
//                     final order = orders[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                       child: ListTile(
//                         title: Text("Order ID: ${order['_id']}"),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Total Amount: ${order['amount']}"),
//                             Text("Status: ${order['payment'] ? "Paid" : "Not Paid"}"),
//                             const Text("Items:"),
//                             ...order['items'].map<Widget>((item) {
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 2.0),
//                                 child: Text(
//                                   "${item['name']} - ${item['quantity']} x ${item['price']}",
//                                 ),
//                               );
//                             }).toList(),
//                           ],
//                         ),
//                         isThreeLine: true,
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }
