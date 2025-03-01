import 'package:card/infrastructure/models/session_state_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionConverter {
  static SessionStateData fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    print("SessionStateData fromFirestore ${data}");
    if (data == null) {
      return SessionStateData(null, false);
    }
    return SessionStateData.fromJson(data);
  }

  static Map<String, Object?> toFirestore(
          SessionStateData sessionState, SetOptions? options) =>
      sessionState.toJson();
}
