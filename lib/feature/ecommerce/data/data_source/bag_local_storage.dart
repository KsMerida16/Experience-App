import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BagLocalStorage {
  static const String bagKey = 'shopping_bag';

  Future<void> saveBag(List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data);
    await prefs.setString(bagKey, jsonString);
  }

  Future<List<dynamic>> loadBag() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(bagKey);

    if (jsonString == null) {
      return [];
    }
    return jsonDecode(jsonString);
  }
}
