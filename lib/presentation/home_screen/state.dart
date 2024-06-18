
import 'package:equatable/equatable.dart';
import 'package:quikapp/data/user_model.dart';

abstract class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object> get props => [];
}

class UserDataLoading extends UserDataState {}

class UserDataLoaded extends UserDataState {
  final UserModel user;

  UserDataLoaded(this.user);
}

class UserDataError extends UserDataState {
  final String message;

  UserDataError(this.message);
}
class LoggedOutSuccess extends UserDataState {

  @override
  List<Object> get props => [];

}
class DeleteAccountLoading extends UserDataState {}

class UserDeleteSuccess extends UserDataState {}

class Loading extends UserDataState {}

