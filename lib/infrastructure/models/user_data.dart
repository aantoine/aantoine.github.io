import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/user/entities/user.dart';

class UserData extends User {
  UserData(super.email, super.name, super.id);

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      json['email'] as String,
      json['name'] as String,
      json['id'] as String,
    );
  }

}

extension UserToJson on User {
  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'id': id,
  };
}