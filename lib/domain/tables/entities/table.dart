import 'package:equatable/equatable.dart';

class Table implements Equatable {
  final String id;
  final String name;
  final String hostId;

  Table(this.id, this.hostId, this.name);

  @override
  List<Object?> get props => [id];

  @override
  bool? get stringify => true;


}