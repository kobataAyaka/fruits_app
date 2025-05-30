// fruit_provider.dart (新しいファイルとして作成)
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fruit_data.dart';

// 果物のデータモデル (Map<String, String> をクラスにするとより型安全になりますが、ここでは簡略化)
// 必要であれば、ここに id プロパティを追加してください。
// 例: final String id; Fruit(this.id, this.name, ...);

// 果物リストを管理する Notifier
class FruitListNotifier extends Notifier<List<Map<String, String>>> {
  @override
  List<Map<String, String>> build() {
    // 初期データ (実際のアプリでは sqflite から読み込むなど)
    // 各果物に 'id' を追加 (例: '1', '2', '3')
    return fruits;
  }

  // 果物を追加するメソッド
  void addFruit(Map<String, String> fruit) {
    // 新しいIDを採番するロジック (ここでは単純な例)
    final newId = (state.length + 1).toString();
    final newFruitWithId = {...fruit, 'id': newId};
    state = [...state, newFruitWithId]; // 状態を新しいリストで更新
  }

  // 果物の名前を更新するメソッド
  void updateFruitName(String id, String newName) {
    state = [
      for (final fruit in state)
        if (fruit['id'] == id)
          {...fruit, 'name': newName} // IDが一致する果物の名前を更新
        else
          fruit,
    ];
  }

  // (オプション) 果物を削除するメソッド
  void removeFruit(String id) {
    state = state.where((fruit) => fruit['id'] != id).toList();
  }
}

// FruitListNotifier を提供する Provider
final fruitListProvider =
    NotifierProvider<FruitListNotifier, List<Map<String, String>>>(() {
  return FruitListNotifier();
});
