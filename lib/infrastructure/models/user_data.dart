import 'package:card/domain/user/entities/user.dart';

extension UserData on User {
  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'id': id,
  };

  static User fromJson(Map<String, dynamic> json) {
    return User(
      json['email'] as String,
      json['name'] as String,
      json['id'] as String,
    );
  }
}