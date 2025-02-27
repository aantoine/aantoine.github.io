import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String name;
  final String id;

  const User(this.email, this.name, this.id);

  @override
  List<Object?> get props => [email, name, id];
}