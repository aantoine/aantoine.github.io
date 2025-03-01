import 'package:card/infrastructure/models/votes_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VotesConverter {
  static VotesData fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception("Illegal state: empty data");
    }
    return VotesData.fromJson(data);
  }

  static Map<String, Object?> toFirestore(
          VotesData votesData, SetOptions? options) =>
      votesData.toJson();
}
