
import 'package:card/domain/planning_session/entities/planning_session.dart';
import 'package:card/domain/tables/entities/table.dart';

abstract class PlanningSessionRepository {
  Stream<PlanningSession> sessionState(Table table);
}