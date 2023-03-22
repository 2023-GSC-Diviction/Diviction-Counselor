import 'package:shared_preferences/shared_preferences.dart';

class Counselor {
  int id;
  String email;
  String password;
  String name;
  String birth;
  String address;
  String gender;
  String? profile_img_url;
  bool confirm;

  Counselor(
      {required this.id,
      required this.email,
      required this.password,
      required this.name,
      required this.address,
      required this.birth,
      required this.gender,
      this.profile_img_url,
      required this.confirm});

  factory Counselor.fromJson(Map<String, dynamic> json) {
    return Counselor(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        name: json['name'],
        address: json['address'],
        birth: json['birth'],
        gender: json['gender'],
        profile_img_url: json['profile_img_url'],
        confirm: json['confirm']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'password': password,
        'name': name,
        'address': address,
        'gender': gender,
        'birth': birth,
        'profile_img_url': profile_img_url,
        'confirm': confirm
      };

  void savePreference(Counselor counselor) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', counselor.email);
    prefs.setString('password', counselor.password);
    prefs.setInt('id', counselor.id);
    prefs.setString('name', counselor.name);
    prefs.setString('address', counselor.address);
    prefs.setString('birth', counselor.birth);
    counselor.profile_img_url == null
        ? prefs.setString('profileUrl', '')
        : prefs.setString('profileUrl', counselor.profile_img_url!);
    prefs.setBool('confirm', counselor.confirm);
  }
}
