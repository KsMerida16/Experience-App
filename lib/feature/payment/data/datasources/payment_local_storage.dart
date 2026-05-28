import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentLocalStorage {
  static const String cardsKey = 'saved_cards';

  Future<void> saveCards(List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data);
    await prefs.setString(cardsKey, jsonString);
  }

  Future<List<dynamic>> loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(cardsKey);

    if (jsonString == null) {
      return [];
    }
    return jsonDecode(jsonString);
  }
}
