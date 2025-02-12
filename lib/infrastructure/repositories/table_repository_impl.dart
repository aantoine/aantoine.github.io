
import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/tables/table_repository.dart';
import 'package:card/infrastructure/sources/authentication/authentication_source.dart';
import 'package:card/infrastructure/sources/persistence/external_persistence_source.dart';
import 'package:uuid/uuid.dart';

class TableRepositoryImplementation extends TableRepository {
  final ExternalPersistenceSource _persistenceSource;
  final AuthenticationSource _authenticationSource;

  TableRepositoryImplementation(this._persistenceSource, this._authenticationSource);

  @override
  Future<Table> createTable() async { //TODO add name
    var currentUser = await _authenticationSource.getUser();
    if (currentUser == null) {
      throw Exception("Invalid state, no user");
    }

    var id = const Uuid().v4();

    var newTable = Table(
      "table_$id",
      [currentUser],
      currentUser.email,
      "Mesa id ${id.substring(id.length - 4)}",
    );

    await _persistenceSource.addTable(newTable);
    await _persistenceSource.enablePresence(currentUser.id);
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
    var update = Table(
      table.id,
      [...table.users, currentUser],
      table.creatorId,
      table.name,
    );

    await _persistenceSource.enablePresence(currentUser.id);
    return _persistenceSource.updateTable(update);
  }

  @override
  Future<void> leaveTable(Table table) async {
    var currentUser = await _authenticationSource.getUser();
    if (currentUser == null) {
      throw Exception("Invalid state, no user");
    }

    await _persistenceSource.disablePresence(currentUser.id);
  }

  @override
  Stream<Table> tableState(Table table) {
    return _persistenceSource.table(table);
  }

}