import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileController extends GetxController {
  RxString address = "".obs;
  RxString birthdate = "".obs;
  RxString birthplace = "".obs;
  RxString nationalnumber = "".obs;
  RxString phone = "".obs;
  RxString gender = "".obs;

  // Address
  Future<void> setAddress(String userAddress) async {
    address.value = userAddress;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_address", userAddress);
  }

  Future<void> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    address.value = prefs.getString("user_address") ?? "";
  }

  // BirthDate

  Future<void> setBirthdate(String userBirthdate) async {
    birthdate.value = userBirthdate;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_birthdate", userBirthdate);
  }

  Future<void> getBirthdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    birthdate.value = prefs.getString("user_birthdate") ?? "";
  }

  // BirthPlace

  Future<void> setBirthplace(String userBirthplace) async {
    birthplace.value = userBirthplace;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_birthplace", userBirthplace);
  }

  Future<void> getBirthplace() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    birthplace.value = prefs.getString("user_birthplace") ?? "";
  }

  // Phone

  Future<void> setPhone(String userPhone) async {
    phone.value = userPhone;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_phone", userPhone);
  }

  Future<void> getPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone.value = prefs.getString("user_phone") ?? "";
  }

  // Gender

  Future<void> setGender(String userGender) async {
    gender.value = userGender;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_gender", userGender);
  }

  Future<void> getGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    gender.value = prefs.getString("user_gender") ?? "";
  }

  // National Number
  Future<void> setNationalNumber(String userNationalNumber) async {
    nationalnumber.value = userNationalNumber;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_national_number", userNationalNumber);
  }

  Future<void> getNationalNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nationalnumber.value = prefs.getString("user_national_number") ?? "";
  }
}
