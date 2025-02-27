import 'package:card/domain/user/entities/user.dart';
import 'package:equatable/equatable.dart';

class UserWithVoteViewModel extends Equatable {
  final User user;
  final String? vote;

  const UserWithVoteViewModel(this.user, this.vote);

  @override
  List<Object?> get props => [user, vote];
}