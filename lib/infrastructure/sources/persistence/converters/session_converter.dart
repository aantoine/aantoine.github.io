import 'package:card/domain/planning_session/entities/planning_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionConverter {

  static PlanningSession fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    throw Exception("Illegal state: empty data");
  }

  static Map<String, Object?> toFirestore(
      PlanningSession sessionState, SetOptions? options) {
    throw Exception("Illegal state: empty data");
  }
}
