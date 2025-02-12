import 'package:card/domain/user/entities/user.dart';
import 'package:equatable/equatable.dart';

class Table implements Equatable {
  final String id;
  final String name;
  final List<User> users;
  final String creatorId;

  Table(this.id, this.users, this.creatorId, this.name);

  @override
  List<Object?> get props => [id];

  @override
  bool? get stringify => true;


}