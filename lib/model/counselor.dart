class Counselor {
  String email;
  String password;
  String name;
  String birth;
  String address;
  String gender;
  String? profile_img_url;
  bool confirm;

  Counselor({
    required this.email,
    required this.password,
    required this.name,
    required this.birth,
    required this.address,
    required this.gender,
    required this.profile_img_url, // path는 디폴트로 'asset/image/DefaultProfileImage.png' 초기화됨 그래서 required 추가함
    required this.confirm,
  });

  factory Counselor.fromJson(Map<String, dynamic> json) {
    return Counselor(
        email: json['email'],
        password: json['password'],
        name: json['name'],
        birth: json['birth'],
        address: json['address'],
        gender: json['gender'],
        profile_img_url: json['profile_img_url'],
        confirm: json['confirm']);
  }
}
