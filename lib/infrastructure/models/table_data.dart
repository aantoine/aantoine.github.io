import 'package:card/domain/tables/entities/table.dart';

extension TableData on Table {
  Map<String, dynamic> toJson() => {
    'id': id,
    //'users': users.map((u) => u.toJson()).toList(),
    'hostId': hostId,
    'name': name,
  };

  static Table fromJson(Map<String, dynamic> json) {
    //Iterable rawUsers = json['users'] as Iterable? ?? [];
    return Table(
      json['id'] as String,
      /*List<User>.from(
        rawUsers.map(
          (model) => UserData.fromJson(
            model as Map<String, dynamic>,
          ),
        ),
      ),*/
      json['hostId'] as String,
      json['name'] as String,
    );
  }
}
