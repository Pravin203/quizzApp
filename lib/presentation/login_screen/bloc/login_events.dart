
import 'package:equatable/equatable.dart';

abstract class LoginScreenEvent extends Equatable {
  const LoginScreenEvent();

  @override
  List<Object> get props => [];
}

class RequestOTPEvent extends LoginScreenEvent {
  final String mobileNumber;
  final Function(String verificationId, int? resendToken) onRequestSuccess;
  final Function(dynamic error) onRequestFailure;

  RequestOTPEvent({
    required this.mobileNumber,
    required this.onRequestSuccess,
    required this.onRequestFailure,
  });
}

class VerifyOTPEvent extends LoginScreenEvent {
  final String verificationId;
  final String otp;

  VerifyOTPEvent({
    required this.verificationId,
    required this.otp,
  });
}