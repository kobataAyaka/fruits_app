import 'package:flutter/material.dart';

import 'fruit_data.dart';
import 'fruit_description_page.dart';

class FruitListPage extends StatelessWidget {
  const FruitListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('과일 리스트'),
      ),
      body: ListView.builder(
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          final fruit = fruits[index];
          return ListTile(
            title: Text(fruit['name']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FruitDescriptionPage(
                    fruit: fruits[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
