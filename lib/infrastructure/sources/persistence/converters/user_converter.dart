import 'package:card/domain/user/entities/user.dart';
import 'package:card/infrastructure/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class UserConverter {
  static final _log = Logger('UserConverter');

  static User fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();

    if (data == null) {
      _log.info('No data found on Firestore');
      throw Exception("Illegal state: empty data");
    }
    return UserData.fromJson(data);
  }

  static Map<String, Object?> toFirestore(
      User user, SetOptions? options) {
    return user.toJson();
  }
}
