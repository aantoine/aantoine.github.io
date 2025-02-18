
import 'package:card/domain/planning_session/entities/planning_session.dart';
import 'package:card/domain/planning_session/planning_session_repository.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:card/infrastructure/sources/persistence/external_persistence_source.dart';

class PlanningSessionRepositoryImpl extends PlanningSessionRepository {
  final ExternalPersistenceSource _persistenceSource;

  PlanningSessionRepositoryImpl(this._persistenceSource);

  @override
  Stream<PlanningSession> sessionState(Table table) {
    return _persistenceSource.session(table);
  }

}