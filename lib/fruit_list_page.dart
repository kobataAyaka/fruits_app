import 'package:flutter/material.dart';

import 'fruit_description_page.dart';

class FruitListPage extends StatelessWidget {
  const FruitListPage({super.key});

  final List<Map<String, String>> fruits = const [
    {'name': '사과', 'calories': '52 kcal', 'scientificName': 'Malus domestica'},
    {
      'name': '감귤',
      'calories': '53 kcal',
      'scientificName': 'Citrus reticulata'
    },
    {'name': '포도', 'calories': '69 kcal', 'scientificName': 'Vitis vinifera'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('과일 리스트'),
      ),
      body: ListView.builder(
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(fruits[index]['name']!),
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
