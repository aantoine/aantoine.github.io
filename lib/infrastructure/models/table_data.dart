import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/user/entities/user.dart';
import 'package:card/infrastructure/models/user_data.dart';

class TableData extends Table {
  TableData(super.id, super.users, super.hostId, super.name);

  factory TableData.fromJson(Map<String, dynamic> json) {
    Iterable rawUsers = json['users'] as Iterable? ?? [];
    return TableData(
      json['id'] as String,
      List<User>.from(
        rawUsers.map(
          (model) => UserData.fromJson(
            model as Map<String, dynamic>,
          ),
        ),
      ),
      json['hostId'] as String,
      json['name'] as String,
    );
  }
}

extension TableToJson on Table {
  Map<String, dynamic> toJson() => {
    'id': id,
    'users': users.map((u) => u.toJson()).toList(),
    'hostId': hostId,
    'name': name,
  };
}
