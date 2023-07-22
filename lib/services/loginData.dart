import 'package:shared_preferences/shared_preferences.dart';

class LoginData {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String firstNameKey = "FIRSTNAMEKEY";
  static String lastNameKey = "LASTNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userProfilePicKey = "USERPROFILEPICEKey";
  static String departmentKey = "DEPARTMENTKEY";
  static String phoneNumberKey = "PHONENUMBERKEY";

  // saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveFirstNameSF(String firstName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(firstNameKey, firstName);
  }

  static Future<bool> saveLastNameSF(String LastName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(lastNameKey, LastName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserProfilePicSF(String userProfilePic) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userProfilePicKey, userProfilePic);
  }

  static Future<bool> saveUserDepartmentSF(String department) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(departmentKey, department);
  }

  static Future<bool> saveUserPhoneNumberSF(String phoneNumber) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(phoneNumberKey, phoneNumber);
  }

  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getFirstNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(firstNameKey);
  }

  static Future<String?> getLastNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(lastNameKey);
  }

  static Future<String?> getDepartmentFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(departmentKey);
  }

  static Future<String?> getPhoneNumberFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(phoneNumberKey);
  }

  static Future<String?> getUserProfilePicFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userProfilePicKey);
  }
}
