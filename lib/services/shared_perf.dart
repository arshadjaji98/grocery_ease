import 'package:shared_preferences/shared_preferences.dart';

class SharedPerfHelper {
  static String userIdKey = "USERKEY";
  static String userNameKey = "USERNAME";
  static String userEmailKey = "USEREMAIL";
  static String userWalletKey = "USERWALLETKEY";
  static String userPhoneKey = "USERPHONE";
  static String userProfileKey = "USERPROFILEKEY";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserWallet(String getUserWallet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userWalletKey, getUserWallet);
  }

  Future<bool> saveUserPhone(String getUserPhone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPhoneKey, getUserPhone);
  }

  Future<bool> saveUserProfile(String getUserProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfileKey, getUserProfile);
  }

  Future<String?> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userIdKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userEmailKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userNameKey);
  }

  Future<String?> getUserWallet() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userWalletKey);
  }

  Future<String?> getUserPhone() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userPhoneKey);
  }

  Future<String?> getUserProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userProfileKey);
  }
}
