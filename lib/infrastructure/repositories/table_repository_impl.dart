import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/tables/table_repository.dart';
import 'package:card/extensions.dart';
import 'package:card/infrastructure/sources/authentication/authentication_source.dart';
import 'package:card/infrastructure/sources/persistence/external_persistence_source.dart';
import 'package:uuid/uuid.dart';

class TableRepositoryImplementation extends TableRepository {
  final ExternalPersistenceSource _persistenceSource;
  final AuthenticationSource _authenticationSource;

  TableRepositoryImplementation(this._persistenceSource, this._authenticationSource);

  @override
  Future<Table> createTable(String name) async {
    var currentUser = await _authenticationSource.getUser();
    if (currentUser == null) {
      throw Exception("Invalid state, no user");
    }

    var id = (Uuid().v4()).takeLast(4);

    var newTable = Table(
      "table_$id",
      currentUser.id,
      name,
    );

    await _persistenceSource.createTable(newTable);
    await joinTable(newTable);

    return newTable;
  }

  @override
  Stream<List<Table>> getCurrentTables() {
    return _persistenceSource.tables();
  }

  @override
  Future<void> joinTable(Table table) async {
    var currentUser = await _authenticationSource.getUser();
    if (currentUser == null) {
      throw Exception("Invalid state, no user");
    }

    await _persistenceSource.addUserTo(table, currentUser);
  }

  @override
  Future<void> leaveTable(Table table) async {
    var currentUser = await _authenticationSource.getUser();
    if (currentUser == null) {
      throw Exception("Invalid state, no user");
    }

    await _persistenceSource.removeUserFrom(table, currentUser);
  }

  @override
  Stream<Table> tableState(Table table) {
    return _persistenceSource.tableStateFor(table);
  }

}