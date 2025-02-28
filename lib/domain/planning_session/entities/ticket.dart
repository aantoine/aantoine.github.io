
import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  final String id;
  final String name;
  final bool revealed;
  final String? result;
  final int totalVotes;

  const Ticket(this.id, this.name, this.revealed, this.result, this.totalVotes);

  @override
  List<Object?> get props => [id, name, revealed, result, totalVotes];
}