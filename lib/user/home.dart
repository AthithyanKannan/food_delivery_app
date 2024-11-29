import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Tomato",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: tomoto,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400, 
                    blurRadius: 10,
                    offset: Offset(0, 4), 
                  ),
                ],
              ),
              height: 200,
              width: 350,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        18),
                    child: Opacity(
                      opacity: 0.979,
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
                            color: Colors.black
                                .withOpacity(0.5),
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
                      'Choose from a diverse menu featuring a delectable array of dishes crafted with the finest and elevate your dining experience, one delicious meal at a time.',
                      maxLines: 3,
                      overflow: TextOverflow
                          .ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal, 
                        shadows: [
                          Shadow(
                            color: Colors.black
                                .withOpacity(0.5),
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
                    child: ElevatedButton(onPressed: (){

                    }, child: const Text('View Menu'),
                    )
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: tomoto,
          selectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.offline_bolt), label: 'My orders'),
          ]),
    );
  }
}
