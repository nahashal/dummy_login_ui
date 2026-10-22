import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String name;

  const CategoryCard({super.key, required this.icon, required this.name});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 35, color: Colors.indigo),

            const SizedBox(height: 8),

            Text(name),
          ],
        ),
      ),
    );
  }
}

class PopularCard extends StatelessWidget {
  final String name;
  final String price;
  final IconData icon;

  const PopularCard({
    super.key,
    required this.name,
    required this.price,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.indigo),

          const SizedBox(height: 15),

          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          Text(price, style: const TextStyle(fontSize: 18, color: Colors.grey)),

          const SizedBox(height: 10),

          ElevatedButton(onPressed: () {}, child: const Text("Add")),
        ],
      ),
    );
  }
}
