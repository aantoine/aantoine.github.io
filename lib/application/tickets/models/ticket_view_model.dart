import 'package:card/domain/planning_session/entities/ticket.dart';
import 'package:equatable/equatable.dart';

class TicketViewModel extends Equatable {
  final Ticket ticket;
  final int votes;
  final bool isActiveTicket;

  const TicketViewModel(this.ticket, this.isActiveTicket, this.votes);

  @override
  List<Object?> get props => [ticket, isActiveTicket, votes];
}