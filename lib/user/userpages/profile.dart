import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<dynamic> orders = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUserOrders();
  }

  Future<void> fetchUserOrders() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    const String url = "http://10.10.64.79:4000/api/order/userorders";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final String? userId = prefs.getString('userId');

      if (token == null || userId == null) {
        if (mounted) {
          setState(() {
            errorMessage = "User not logged in.";
          });
        }
        return;
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success']) {
          if (mounted) {
            setState(() {
              orders = responseData['data'];
            });
          }
        } else {
          if (mounted) {
            setState(() {
              errorMessage =
                  responseData['message'] ?? "Failed to fetch orders.";
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage =
                "Server error: ${response.statusCode}. Try again later.";
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "Error: $e";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : orders.isEmpty
                  ? const Center(child: Text("No orders found."))
                  : ListView.builder(
                      padding: const EdgeInsets.all(25),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final items = order['items'] as List<dynamic>;
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order ID: ${order['_id']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Items: ${items.map((item) => "${item['name']} x ${item['quantity']}").join(", ")}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Total Amount: \$${order['amount']}.00",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Item Count: ${items.length}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      order['status'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: fetchUserOrders,
                                  child: const Text("Track Order"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
