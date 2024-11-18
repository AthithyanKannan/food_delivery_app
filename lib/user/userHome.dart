import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  List<dynamic> foodItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFoodItems();
  }

  Future<void> fetchFoodItems() async {
    try {
      final response =
          await http.get(Uri.parse("http://10.10.69.244:4000/api/food/list"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            foodItems = data['data'];
            isLoading = false;
          });
        } else {
          throw Exception("Failed to fetch data");
        }
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Cart"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : foodItems.isEmpty
              ? Center(child: Text("No food items found."))
              : ListView.builder(
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    final food = foodItems[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: food['image'] != null
                            ? Image.network(
                                "http://10.10.69.244:4000/uploads/${food['image']}",
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.fastfood, size: 50),
                        title: Text(food['name'] ?? "Unnamed Food"),
                        subtitle: Text(
                          "${food['description']}\nCategory: ${food['category']}",
                        ),
                        trailing: Text("\$${food['price']}"),
                      ),
                    );
                  },
                ),
    );
  }
}
