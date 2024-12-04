import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/components/colors.dart';
// import 'package:food_delivery_app/user/cart.dart';
import 'package:food_delivery_app/user/userpages/cart.dart';
import 'package:food_delivery_app/user/userpages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> foodItems = [];
  List<dynamic> cartItems = [];
  bool isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchFoodItems();
  }

  Future<void> fetchFoodItems() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse("http://10.10.64.79:4000/api/food/list"),
        headers: {'token': token ?? ''},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          if (mounted) {
            setState(() {
              foodItems = data['data'];
              isLoading = false;
            });
          }
        } else {
          throw Exception("Failed to fetch data");
        }
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print("Error: $e");
    }
  }

  void addToCart(dynamic food) {
    setState(() {
      cartItems.add(food);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 100),
        content: Text("${food['name']} added to cart!"),
        backgroundColor: tomoto,
      ),
    );
  }

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
          "HungryJi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Cart(cartItems: cartItems)),
              );
            },
            icon: const Icon(
              Icons.wallet,
              size: 30,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: tomoto,
      ),
      body: _currentIndex == 0 ? _buildHomeContent() : const Profile(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: tomoto,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return isLoading
        ? _buildShimmerEffect()
        : SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: _buildHeader(),
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    SizedBox(width: 30),
                    Text(
                      "Top dishes near you",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                ...foodItems.map((food) => _buildFoodCard(food)),
              ],
            ),
          );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      height: 200,
      width: 350,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Opacity(
              opacity: 0.879,
              child: Image.asset(
                'assets/images/header_img.png',
                fit: BoxFit.cover,
                height: 200,
                width: 350,
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            left: 15,
            child: Text(
              'Order your favorite food here',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 15,
            right: 15,
            child: Text(
              'Choose from a diverse menu featuring a delectable array of dishes crafted with the finest ingredients.',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 15,
            right: 15,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {},
              child: const Text(
                'View Menu',
                style: TextStyle(
                  color: tomoto,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(dynamic food) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(food['name'] ?? 'Unnamed Dish'),
            subtitle: Text(
              "${food['description']}\nCategory: ${food['category']}",
            ),
            trailing: Text("\$${food['price']}"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => addToCart(food),
                icon: const Icon(
                  Icons.add,
                  size: 28,
                  color: tomoto,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ListTile(
              title: Container(
                height: 16,
                color: Colors.grey.shade300,
              ),
              subtitle: Container(
                height: 14,
                color: Colors.grey.shade300,
              ),
              trailing: Container(
                height: 16,
                width: 50,
                color: Colors.grey.shade300,
              ),
            ),
          ),
        );
      },
    );
  }
}
