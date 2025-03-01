
import 'package:equatable/equatable.dart';

class VotesData extends Equatable {
  final String userId;
  final String value;

  const VotesData(this.userId, this.value);

  Map<String, dynamic> toJson() {
   return {
     "userId": userId,
     "value": value,
   };
  }

  static VotesData fromJson(Map<String, dynamic> json) {
    return VotesData(
      json["userId"] as String,
      json["value"] as String,
    );
  }

  @override
  List<Object?> get props => [userId];
}