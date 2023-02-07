import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStore {
  LocalStore._();

  static setDocId(String docId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("docId", docId);
  }

  static Future<String?> getDocId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("docId");
  }

  static storeClear() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}
