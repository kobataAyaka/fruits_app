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
          // 画像部分を追加
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.2),
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    'assets/images/${fruit['imageFileName']}',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
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
