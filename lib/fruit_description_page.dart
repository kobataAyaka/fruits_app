import 'package:flutter/material.dart';

class FruitDescriptionPage extends StatelessWidget {
  final Map<String, String> fruit;

  const FruitDescriptionPage({super.key, required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fruit['name']!),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('이름'),
            subtitle: Text(fruit['name']!),
          ),
          ListTile(
            title: const Text('열량'),
            subtitle: Text(fruit['calories']!),
          ),
          ListTile(
            title: const Text('학명'),
            subtitle: Text(fruit['scientificName']!),
          ),
        ],
      ),
    );
  }
}
