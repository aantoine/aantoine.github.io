import 'package:card/domain/planning_session/entities/ticket.dart';
import 'package:equatable/equatable.dart';

class TicketViewModel extends Equatable {
  final Ticket ticket;
  final int totalVotes;
  final bool isActiveTicket;
  final String parsedVotes;
  final String result;

  const TicketViewModel(this.ticket, this.isActiveTicket, this.totalVotes, this.parsedVotes, this.result);

  @override
  List<Object?> get props => [ticket, isActiveTicket, totalVotes];
}