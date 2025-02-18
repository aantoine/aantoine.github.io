import 'package:card/domain/tables/entities/table.dart';
import 'package:card/infrastructure/models/table_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class TableConverter {
  static final _log = Logger('TableConverter');

  static Table fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    if (data == null) {
      _log.info('No data found on Firestore, returning empty list');
      //return [];
      throw Exception("Illegal state: empty data");
    }
    return TableData.fromJson(data);
  }

  static Map<String, Object?> toFirestore(
      Table table, SetOptions? options) {
    return table.toJson();
  }
}
