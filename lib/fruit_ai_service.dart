// fruit_ai_service.dart
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FruitAiService {
  final GenerativeModel model;
  FruitAiService(this.model);

  Future<Map<String, String>?> getFruitInfo(String fruitName) async {
    final prompt = [Content.text(_buildPrompt(fruitName))];
    try {
      // Vertex AI SDK を使ってプロンプトを送信 (実際の実装はSDKの仕様に合わせる)
      final response = await model.generateContent(prompt);
      final text = response.text; // 仮のレスポンス取得

      if (text != null) {
        return _parseResponse(text);
      }
      return null;
    } catch (e) {
      print("Error fetching fruit info: $e");
      return null;
    }
  }

  String _buildPrompt(String fruitName) {
    return """
    You are a helpful assistant.
    Given the fruit name: "$fruitName"
    Provide its typical calories per 100g and its scientific name.
    Format your answer strictly as:
    Calories: [calories_value] kcal
    Scientific Name: [scientific_name_value]
    """;
    // プロンプトは調整が必要
  }

  Map<String, String>? _parseResponse(String responseText) {
    try {
      final caloriesMatch =
          RegExp(r"Calories: (.*?) kcal").firstMatch(responseText);
      final scientificNameMatch =
          RegExp(r"Scientific Name: (.*)").firstMatch(responseText);

      if (caloriesMatch != null && scientificNameMatch != null) {
        return {
          'calories': caloriesMatch.group(1)!.trim(),
          'scientificName': scientificNameMatch.group(1)!.trim(),
        };
      }
      return null;
    } catch (e) {
      print("Error parsing response: $e");
      return null;
    }
  }
}

// Riverpod Provider (オプション)
final fruitAiServiceProvider = Provider<FruitAiService>((ref) {
  final model = ref.watch(generativeModelProvider);
  return FruitAiService(model);
});

final generativeModelProvider = Provider<GenerativeModel>((ref) {
  final model =
      FirebaseAI.googleAI().generativeModel(model: 'gemini-2.0-flash');
  return model;
});
