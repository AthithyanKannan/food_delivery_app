import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/colors.dart';
import 'package:toastification/toastification.dart';

class Cart extends StatefulWidget {
  final List<dynamic> cartItems;

  const Cart({super.key, required this.cartItems});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    super.initState();
    _updateCartItems(); 
  }

  void _updateCartItems() {
    List<dynamic> updatedItems = [];
    for (var item in widget.cartItems) {
      bool itemExists = false;
      final price = item['price'] ?? 0.0;
      final quantity = item['quantity'] ?? 1;

      for (var updatedItem in updatedItems) {
        if (updatedItem['name'] == item['name']) {
          updatedItem['quantity'] = (updatedItem['quantity'] ?? 1) + quantity; // Increase quantity
          itemExists = true;
          break;
        }
      }

      if (!itemExists) {
        updatedItems.add({
          'name': item['name'],
          'price': price,
          'quantity': quantity,
        });
      }
    }
    setState(() {
      widget.cartItems.clear();
      widget.cartItems.addAll(updatedItems);
    });
  }

  void _removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index); 
    });

    toastification.show(
      context: context,
      title: const Text("Item Removed"),
      description: const Text("Item removed from cart."),
      backgroundColor: Colors.red,
    );
  }

  double getTotalPrice() {
    return widget.cartItems.fold(
      0.0,
      (sum, item) {
        final price = item['price'] ?? 0.0;
        final quantity = item['quantity'] ?? 1;
        return sum + (price * quantity);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        shadowColor: tomoto,
        title: const Text(
          "Cart",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: tomoto,
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : SingleChildScrollView(
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 30.0),
                    child: Table(
                      columnWidths: const {
                        0: FixedColumnWidth(130),
                        1: FixedColumnWidth(100),
                        2: FixedColumnWidth(80),
                      },
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(228, 100, 23, 0.2),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 8.0),
                              child: Text(
                                "Title",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Total",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Remove",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...widget.cartItems.map(
                          (item) {
                            final price = item['price'] ?? 0.0;
                            final quantity = item['quantity'] ?? 1;
                            final total = (price * quantity).toStringAsFixed(2);
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    "${item['name']} x $quantity",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                    ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text("\$$total"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _removeItem(widget.cartItems.indexOf(item));
                                    },
                                    child: const Icon(
                                      Icons.cancel,
                                     color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Total: \$${getTotalPrice().toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
          ),
    );
  }
}
