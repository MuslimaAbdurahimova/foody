

import 'address_model.dart';

class UserModel {
  final String? name;
  final String? username;
  final String? password;
  final String? avatar;
  final String? bio;
  final String? birth;
  final String? email;
  final String? gender;
  final String? phone;
  final List? likes;
  final AddressModel? address;

  UserModel(
      {required this.name,
      required this.username,
      required this.password,
      this.avatar,
      this.bio,
      required this.birth,
      required this.email,
      required this.gender,
      required this.phone,
      this.likes,
      this.address});

  factory UserModel.fromJson(Map<String, dynamic>? data) {
    return UserModel(
        name: data?["name"],
        username: data?["username"],
        password: data?["password"],
        avatar: data?["avatar"],
        bio: data?["bio"],
        birth: data?["birth"],
        email: data?["email"],
        gender: data?["gender"],
        phone: data?["phone"],
        likes: data?["array"],
        address: data?["address"] != null
            ? AddressModel.fromJson(data?["address"])
            : null);
  }

  toJson() {
    return {
      "name": name,
      "username": username,
      "password": password,
      "avatar": avatar,
      "bio": bio,
      "birth": birth,
      "email": email,
      "gender": gender,
      "phone": phone,
      if (likes != null)
        "likes": List<dynamic>.from(likes!.map((x) => x.toJson())),
      "address": address?.toJson()
    };
  }
}
