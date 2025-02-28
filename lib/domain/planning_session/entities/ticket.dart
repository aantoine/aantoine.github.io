
import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  final String id;
  final String name;

  final bool resolved;
  final List<String> votes;
  final String? result;

  const Ticket(this.id, this.name, {this.resolved = false, this.result, this.votes = const []});

  @override
  List<Object?> get props => [id, name, resolved, result, votes];
}