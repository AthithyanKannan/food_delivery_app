import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final List<dynamic> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(
      0,
      (sum, item) => sum + (item['price']),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(item['name']),
                          subtitle: Text("Price: \$${item['price']}"),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_shopping_cart),
                            onPressed: () {
                              Navigator.pop(context);
                              cartItems.removeAt(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Total: \$${totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
