import 'package:equatable/equatable.dart';

abstract class UserDataEvent extends Equatable {
  UserDataEvent();

  @override
  List<Object> get props => [];
}

class FetchUserData extends UserDataEvent {
  final String UserId;

  FetchUserData(this.UserId);
}

class LogoutEvent extends UserDataEvent {
  @override
  List<Object> get props => [];
}

class DeleteUserEvent extends UserDataEvent {}
