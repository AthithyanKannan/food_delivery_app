import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final String url = "http://10.10.64.116:4000";
  List<dynamic> foodList = [];

  @override
  void initState() {
    super.initState();
    fetchList();
  }

  Future<void> fetchList() async {
    try {
      final response = await http.get(Uri.parse("$url/api/food/list"));
      final data = json.decode(response.body);
      if (data['success'] == true) {
        if (mounted) {
          setState(() {
            foodList = data['data'];
          });
        }
      } else {
        _showToast("Error fetching list", Colors.red);
      }
    } catch (error) {
      _showToast("API call failed", Colors.red);
    }
  }

  Future<void> removeFood(String foodId) async {
    try {
      final response = await http.post(
        Uri.parse("$url/api/food/remove"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': foodId}),
      );
      final data = json.decode(response.body);
      if (data['success'] == true) {
        _showToast(data['message'], Colors.green);
        await fetchList();
      } else {
        _showToast("Error", Colors.red);
      }
    } catch (error) {
      _showToast("API call failed", Colors.red);
    }
  }

  void _showToast(String message, Color color) {
    if (!mounted) return;
    toastification.show(
      context: context,
      title: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Food List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          foodList.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: foodList.length,
                    itemBuilder: (context, index) {
                      final item = foodList[index];
                      return ListTile(
                        leading: Image.network("$url/images/${item['image']}"),
                        title: Text(item['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Category: ${item['category']}"),
                            Text("Price: \$${item['price']}"),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeFood(item['_id']),
                        ),
                      );
                    },
                  ),
                )
              : const Expanded(
                  // Add Expanded to ensure proper layout even if list is empty
                  child: Center(
                    child: Text("No data available"),
                  ),
                ),
        ],
      ),
    );
  }
}
