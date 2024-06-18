import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikapp/domain/firebase_auth_service/auth_service.dart';
import 'package:quikapp/presentation/login_screen/bloc/login_events.dart';
import 'package:quikapp/presentation/login_screen/bloc/login_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  final FirebaseAuthService authService;

  // final FacebookAuthService facebookAuthService;

  LoginScreenBloc(
    this.authService,
  ) : super(LoginScreenInitial()) {
    on<RequestOTPEvent>((event, emit) async {
      try {
        emit(LoginLoading());
        authService.requestOTP(
            event.mobileNumber, event.onRequestSuccess, event.onRequestFailure);
        emit(RequestOTPSuccess());
      } catch (e) {
        print("print error $e");
      }
    });

    on<VerifyOTPEvent>((event, emit) async {
      try {
        emit(LoginLoading());
        final result = authService.verifyOTP(event.verificationId, event.otp);
        emit(VerifySuccess(result.toString()));
      } catch (e) {
        emit(VerifyOTPFailure("VerifyOTPFailure error: ${e.toString()}"));
      }
    });
  }
}
