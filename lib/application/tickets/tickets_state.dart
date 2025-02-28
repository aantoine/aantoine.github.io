part of 'tickets_cubit.dart';

class TicketsState extends Equatable {
  final List<TicketViewModel> tickets;
  final bool adding;

  const TicketsState({this.tickets = const [], this.adding = false});

  @override
  List<Object?> get props => [tickets, adding];
}
