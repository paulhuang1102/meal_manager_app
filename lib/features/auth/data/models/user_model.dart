import 'dart:convert';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] as String,
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory UserModel.fromJsonString(String jsonString) {
    return UserModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      username: user.username,
    );
  }
}
