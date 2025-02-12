
import 'package:card/domain/tables/entities/table.dart';

abstract class TableRepository {
  Stream<List<Table>> getCurrentTables();
  Future<void> joinTable(Table table);
  Future<Table> createTable();

  Stream<Table> tableState(Table table);
  Future<void> leaveTable(Table table);
}