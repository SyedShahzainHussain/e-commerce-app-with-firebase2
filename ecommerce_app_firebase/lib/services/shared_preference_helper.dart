import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static Future<void> saveUser(
    String email,
    String password,
    String userID,
    String userName,
    String wallet,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("USERNAME", userName);
    sharedPreferences.setString("PASSWORD", password);
    sharedPreferences.setString("EMAIL", email);
    sharedPreferences.setString("USERID", userID);
    sharedPreferences.setString("WALLET", wallet);
  }

  static Future<Map<String, dynamic>> getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? username = sharedPreferences.getString("USERNAME") ?? "";
    String? password = sharedPreferences.getString("PASSWORD") ?? "";
    String? email = sharedPreferences.getString("EMAIL") ?? "";
    String? userid = sharedPreferences.getString("USERID") ?? "";
    String? wallet = sharedPreferences.getString("WALLET") ?? "0";
    String? profile = sharedPreferences.getString("PROFILE") ?? "";

    return {
      "username": username,
      "password": password,
      "email": email,
      "userId": userid,
      "wallet": wallet,
      "profile": profile,
    };
  }

  static Future<void> updateWallet(String wallet) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("WALLET", wallet);
  }

  static Future<void> updateProfilePic(String profile) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("PROFILE", profile);
  }
}
