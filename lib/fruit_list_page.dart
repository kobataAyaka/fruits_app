import 'package:flutter/material.dart';

import 'add_fruit_page.dart';
import 'fruit_data.dart';
import 'fruit_description_page.dart';

class FruitListPage extends StatefulWidget {
  const FruitListPage({super.key});

  @override
  State<FruitListPage> createState() => _FruitListPageState();
}

class _FruitListPageState extends State<FruitListPage> {
  void _navigateToAddFruitPage() async {
    // Navigator.push で入力画面に遷移し、結果を受け取る
    final newFruit = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => const AddFruitPage()),
    );

    if (newFruit != null) {
      // 返されたデータがあれば、リストに追加してUIを更新
      setState(() {
        // 必要であれば、新しいIDをここで付与する
        // final newId = (_fruits.length + 1).toString();
        // _fruits.add({...newFruit, 'id': newId});
        fruits.add(newFruit);
      });
    }
  }

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
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      fruit: fruits[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddFruitPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
