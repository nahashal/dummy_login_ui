import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../widgets/menu_cards.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<bool> showExitDialog(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Exit"),
          content: const Text("Are you sure you want to exit?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final shouldExit = await showExitDialog(context);

        if (shouldExit && context.mounted) {
          Navigator.pop(context);
        }
      },

      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Dummy_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),

        child: Scaffold(
          backgroundColor: Colors.transparent,

          drawer: const AppDrawer(),

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,

            title: const Text(
              "Ice Cream",
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "What are you craving?",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                TextField(
                  decoration: InputDecoration(
                    hintText: "Search ice cream...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Categories",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    CategoryCard(icon: Icons.icecream, name: "Ice Cream"),

                    const SizedBox(width: 15),

                    CategoryCard(icon: Icons.cake, name: "Cakes"),

                    const SizedBox(width: 15),

                    CategoryCard(icon: Icons.local_drink, name: "Shakes"),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  "Popular",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: PopularCard(
                        name: "Chocolate",
                        price: "₹120",
                        icon: Icons.icecream,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: PopularCard(
                        name: "Vanilla",
                        price: "₹100",
                        icon: Icons.icecream,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
