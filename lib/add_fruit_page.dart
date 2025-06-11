// add_fruit_page.dart (新しいファイルとして作成)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fruit_ai_service.dart'; // 作成したサービスクラスをインポート

class AddFruitPage extends ConsumerStatefulWidget {
  const AddFruitPage({super.key});

  @override
  ConsumerState<AddFruitPage> createState() => _AddFruitPageState();
}

class _AddFruitPageState extends ConsumerState<AddFruitPage> {
  // ConsumerState に変更
  final _formKey = GlobalKey<FormState>();
  String _fruitName = '';
  String _calories = '50 kcal'; // 初期値またはAIからの取得値
  String _scientificName = 'Genus species'; // 初期値またはAIからの取得値
  final String _imageFileName = 'placeholder.png';

  bool _isLoadingAiData = false; // AIデータ取得中のローディングフラグ

  // AIから情報を取得するメソッド
  Future<void> _fetchFruitInfoFromAi(String fruitName) async {
    if (fruitName.isEmpty) return;

    setState(() {
      _isLoadingAiData = true;
    });

    try {
      // Riverpod経由でサービスを取得する場合
      final aiService = ref.read(fruitAiServiceProvider);
      final info = await aiService.getFruitInfo(fruitName);

      // // 直接インスタンス化する場合 (Providerを使わないなら)
      // final aiService =
      //     FruitAiService(/* Vertex AI instance */); // VertexAIのインスタンスを渡す
      // final info = await aiService.getFruitInfo(fruitName);

      if (info != null) {
        setState(() {
          _calories = info['calories'] ?? _calories;
          _scientificName = info['scientificName'] ?? _scientificName;
        });
      } else {
        // 情報を取得できなかった場合のエラーハンドリング
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AIから情報を取得できませんでした。手動で入力してください。')),
        );
      }
    } catch (e, stackTrace) {
      // stackTrace も取得
      debugPrint('エラー発生: $e');
      debugPrint('スタックトレース: $stackTrace'); // スタックトレースも出力
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                '情報取得中にエラーが発生しました。詳細はコンソールを確認してください。')), // SnackBar には簡潔なメッセージ
      );
    } finally {
      setState(() {
        _isLoadingAiData = false;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newFruit = {
        'name': _fruitName,
        'calories': _calories,
        'scientificName': _scientificName,
        'imageFileName': _imageFileName,
      };
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
        child: Form(
          key: _formKey,
          child: ListView(
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
                // 名前が変更されたらAIに問い合わせる (例: onFieldSubmitted やボタン)
                onFieldSubmitted: (value) {
                  _fetchFruitInfoFromAi(value);
                },
              ),
              // AIから情報を取得するためのボタン (オプション)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _isLoadingAiData
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('カロリーと学名を自動入力'),
                        onPressed: () {
                          // TextFormFieldから現在の名前を取得してAIに渡す
                          final currentFormState = _formKey.currentState;
                          if (currentFormState != null &&
                              currentFormState.validate()) {
                            currentFormState.save(); // _fruitName を更新
                            _fetchFruitInfoFromAi(_fruitName);
                          }
                        },
                      ),
              ),
              const SizedBox(height: 10),
              // カロリー (AIが入力するか、手動で編集可能にするか)
              TextFormField(
                // controller を使って値を更新する方が良いかも
                key: ValueKey(_calories), // AIによって値が変わるのでキーを指定
                initialValue: _calories,
                decoration: const InputDecoration(
                  labelText: 'カロリー',
                  border: OutlineInputBorder(),
                  // suffixIcon: Icon(Icons.local_fire_department),
                ),
                onSaved: (value) => _calories = value ?? _calories,
                // readOnly: true, // AIで入力されたら編集不可にする場合
              ),
              const SizedBox(height: 20),
              // 学名 (AIが入力するか、手動で編集可能にするか)
              TextFormField(
                key: ValueKey(_scientificName), // AIによって値が変わるのでキーを指定
                initialValue: _scientificName,
                decoration: const InputDecoration(
                  labelText: '学名',
                  border: OutlineInputBorder(),
                  // suffixIcon: Icon(Icons.science),
                ),
                onSaved: (value) => _scientificName = value ?? _scientificName,
                // readOnly: true, // AIで入力されたら編集不可にする場合
              ),
              const SizedBox(height: 20),
              // 画像 (変更なし)
              ListTile(
                title: const Text('画像 (初期値)'),
                subtitle: const Text('placeholder.png'),
                leading: const Icon(Icons.image),
                onTap: () {
                  // TODO: 画像選択機能を実装するならここ
                },
              ),
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
