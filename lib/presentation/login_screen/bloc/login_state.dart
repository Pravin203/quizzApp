import 'package:equatable/equatable.dart';

abstract class LoginScreenState extends Equatable {
  const LoginScreenState();

  @override
  List<Object> get props => [];
}

class LoginScreenInitial extends LoginScreenState {}

class LoginLoading extends LoginScreenState {}

class RequestOTPSuccess extends LoginScreenState {}

class RequestOTPFailure extends LoginScreenState {
  final String error;

  RequestOTPFailure(this.error);

  @override
  List<Object> get props => [error];
}

class VerifySuccess extends LoginScreenState {
  final String result;

  VerifySuccess(this.result);

  @override
  List<Object> get props => [result];
}

class VerifyOTPFailure extends LoginScreenState {
  final String error;

  VerifyOTPFailure(this.error);

  @override
  List<Object> get props => [error];
}
