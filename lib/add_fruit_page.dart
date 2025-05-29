// add_fruit_page.dart (新しいファイルとして作成)
import 'package:flutter/material.dart';

class AddFruitPage extends StatefulWidget {
  const AddFruitPage({super.key});

  @override
  State<AddFruitPage> createState() => _AddFruitPageState();
}

class _AddFruitPageState extends State<AddFruitPage> {
  final _formKey = GlobalKey<FormState>();
  String _fruitName = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // 新しい果物データを作成 (初期値を含む)
      final newFruit = {
        'name': _fruitName,
        'calories': '50 kcal', // 初期値
        'scientificName': 'Genus species', // 初期値
        'imageFileName': 'placeholder.png', // 初期値 (適切な画像を用意してください)
        // 必要に応じて 'id' もユニークに生成するロジックを追加
      };
      // Navigator.pop で新しい果物データを元の画面に返す
      Navigator.pop(context, newFruit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新しい果物を追加'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Formウィジェットで入力フィールドをグループ化
        child: Form(
          key: _formKey,
          child: ListView( // 今後項目が増えることを考慮してListViewを使用
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '果物の名前',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '果物の名前を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _fruitName = value!;
                },
              ),
              const SizedBox(height: 20), // 少しスペースを空ける
              // --- ここから下は将来的に入力項目にする部分 (今は表示のみか、固定値) ---
              ListTile(
                title: const Text('カロリー (初期値)'),
                subtitle: const Text('50 kcal'),
                leading: Icon(Icons.local_fire_department),
              ),
              ListTile(
                title: const Text('学名 (初期値)'),
                subtitle: const Text('Genus species'),
                leading: Icon(Icons.science),
              ),
              ListTile(
                title: const Text('画像 (初期値)'),
                subtitle: const Text('placeholder.png'),
                leading: Icon(Icons.image),
              ),
              // --- ここまで ---
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('追加する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}