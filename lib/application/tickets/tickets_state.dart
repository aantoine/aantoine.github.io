part of 'tickets_cubit.dart';

class TicketsState extends Equatable {
  final List<TicketViewModel> tickets;
  final bool adding;
  final bool isHost;

  const TicketsState({
    this.tickets = const [],
    this.adding = false,
    this.isHost = false,
  });

  @override
  List<Object?> get props => [tickets, adding, isHost];
}
