import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_fruit_page.dart';
import 'fruit_description_page.dart';
import 'fruit_provider.dart';

class FruitListPage extends ConsumerWidget {
  const FruitListPage({super.key});

  void _navigateToAddFruitPage(BuildContext context, WidgetRef ref) async {
    final newFruitData = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => const AddFruitPage()),
    );

    if (newFruitData != null) {
      ref.read(fruitListProvider.notifier).addFruit(newFruitData);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fruits = ref.watch(fruitListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('과일 리스트'),
      ),
      body: fruits.isEmpty
          ? const Center(child: Text('과일이 없습니다. 추가해 주세요.'))
          : ListView.builder(
              itemCount: fruits.length,
              itemBuilder: (context, index) {
                final fruit = fruits[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      // backgroundImage: AssetImage('assets/images/${fruit['imageFileName']}'),
                      // もし画像ファイルがない場合はプレースホルダーアイコン
                      child: fruit['imageFileName'] == 'placeholder.png'
                          ? Image.asset(
                              'assets/images/placeholder.png',
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.hide_image),
                            ) // プレースホルダー用のアイコン
                          : Image.asset(
                              'assets/images/${fruit['imageFileName']!}',
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.hide_image), // 画像読み込みエラー時
                            ),
                    ),
                    title: Text(fruit['name']!),
                    subtitle: Text(fruit['calories']!),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FruitDescriptionPage(
                            fruitId: fruit['id']!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddFruitPage(context, ref),
        tooltip: '새로운 과일 추가',
        child: const Icon(Icons.add),
      ),
    );
  }
}
