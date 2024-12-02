import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

class Orders extends StatefulWidget {
  const Orders({
    Key? key,
  }) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<dynamic> orders = [];
  final String url = "http://10.10.64.116:4000";

  @override
  void initState() {
    super.initState();
    fetchAllOrders();
  }

  Future<void> fetchAllOrders() async {
    try {
      final response = await http.get(Uri.parse("${url}/api/order/list"));
      final data = json.decode(response.body);
      if (data['success'] == true) {
        setState(() {
          orders = data['data'];
        });
      } else {
        showToast("Error fetching orders", Colors.red);
      }
    } catch (error) {
      showToast("Failed to fetch orders", Colors.red);
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await http.post(
        Uri.parse("${url}/api/order/status"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'orderId': orderId, 'status': status}),
      );
      final data = json.decode(response.body);
      if (data['success'] == true) {
        fetchAllOrders();
        showToast("Order status updated", Colors.green);
      } else {
        showToast("Failed to update status", Colors.red);
      }
    } catch (error) {
      showToast("API call failed", Colors.red);
    }
  }

  void showToast(String message, Color color) {
        if (!mounted) return;

    toastification.show(
      context: context,
      title: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Order Page",
          style: TextStyle(
            fontSize: 18
          ),
          ),
      ),
      body: orders.isNotEmpty
          ? ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  color: Colors.white,
                  shadowColor: Colors.black,
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['items']
                              .map<String>((item) =>
                                  "${item['name']} x ${item['quantity']}")
                              .join(", "),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),

                        Text(
                          "${order['address']['firstName']} ${order['address']['lastName']}",
                        ),
                        const SizedBox(height: 4.0),

                        Text(
                          "${order['address']['street']}, ${order['address']['city']}, ${order['address']['state']}, ${order['address']['country']}",
                        ),
                        const SizedBox(height: 4.0),

                        Text("Phone: ${order['address']['phone']}"),
                        const SizedBox(height: 8.0),

                        Text("Amount: \$${order['amount']}"),
                        const SizedBox(height: 8.0),

                        DropdownButton<String>(
                          value: order['status'],
                          items: const [
                            DropdownMenuItem(
                              value: "Food Processing",
                              child: Text("Food Processing"),
                            ),
                            DropdownMenuItem(
                              value: "Out for delivery",
                              child: Text("Out for delivery"),
                            ),
                            DropdownMenuItem(
                              value: "Delivered",
                              child: Text("Delivered"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              updateOrderStatus(order['_id'], value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text("No orders available"),
            ),
    );
  }
}
