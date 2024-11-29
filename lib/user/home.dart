import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/colors.dart';
import 'package:food_delivery_app/user/ip.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
            ),
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Ip(),));
          }, icon: const Icon(
            Icons.wallet,
            size: 30,
            color: Colors.white,
          ))
        ],
        backgroundColor: tomoto,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
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
                        'Choose from a diverse menu featuring a delectable array of dishes crafted with the finest and elevate your dining experience, one delicious meal at a time.',
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
                          onPressed: () {},
                          child: const Text('View Menu'),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(children: [
              SizedBox(
                width: 30,
              ),
              Text(
                "Top dishes near you",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
            cardWidget(),
            cardWidget(),
            cardWidget(),
            cardWidget()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: tomoto,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}

Widget cardWidget() {
  return Card(
    color: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ListTile(
          title: Text('The Enchanted Nightingale'),
          subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add,
                  size: 28,
                  color: tomoto,
                )),
            const SizedBox(width: 8),
          ],
        ),
      ],
    ),
  );
}
