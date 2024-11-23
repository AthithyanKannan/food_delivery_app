import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  final List<dynamic> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double getTotalPrice() {
    return widget.cartItems.fold(
      0.0,
      (sum, item) {
        final price = item['price'] ?? 0.0; // Default price to 0.0 if null
        final quantity = item['quantity'] ?? 1; // Default quantity to 1 if null
        return sum + (price * quantity);
      },
    );
  }

  Future<void> placeOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    final String? token = prefs.getString('token');
    print("userId");
    print(userId);

    if (userId == null || token == null) {
      Fluttertoast.showToast(msg: "User not logged in.");
      return;
    }

    try {
      // Construct order data
      final orderData = {
        "userId": userId,
        "items": widget.cartItems.map((item) {
          return {
            "name": item['name'],
            "price": item['price'],
            "quantity": item['quantity'],
          };
        }).toList(),
        "amount": getTotalPrice() + 2, // Including delivery charge
        "address": {
          "street": "Example Street",
          "city": "Example City",
          "state": "Example State",
          "zipcode": "12345",
          "country": "Example Country",
          "phone": "1234567890"
        }
      };

      // Call the backend to place the order
      final response = await http.post(
        Uri.parse("http://10.10.66.71:4000/api/order/place"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          // Order placed successfully
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Order placed successfully!"),
              backgroundColor: Colors.green,
            ),
          );

          // Clear cart
          setState(() {
            widget.cartItems.clear();
          });
        } else {
          Fluttertoast.showToast(msg: "Failed to place order.");
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to contact the backend.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    
    double totalPrice = getTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return ListTile(
                        title: Text(item['name']),
                        subtitle: Text("Price: \$${item['price']}"),
                        trailing: Text("Qty: ${item['quantity']}"),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Total: \$${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: placeOrder,
                    child: const Text("Place Order"),
                  ),
                ),
              ],
            ),
    );
  }
}
