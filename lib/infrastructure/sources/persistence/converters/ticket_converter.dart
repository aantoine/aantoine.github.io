import 'package:card/domain/planning_session/entities/ticket.dart';
import 'package:card/infrastructure/models/ticket_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class TicketConverter {
  static final _log = Logger('TicketConverter');

  static List<Ticket> fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();

    if (data == null) {
      return [];
    }
    return TicketData.fromJson(data).tickets;
  }

  static Map<String, Object?> toFirestore(
      List<Ticket> tickets, SetOptions? options) {
    return TicketData(tickets).toJson();
  }
}
