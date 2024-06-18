

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikapp/data/user_model.dart';
import 'package:quikapp/domain/firebase_service/firebase_service.dart';
import 'package:quikapp/presentation/home_screen/events.dart';
import 'package:quikapp/presentation/home_screen/state.dart';

class UserCardDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserCardDataBloc() : super(UserDataLoading()) {
    on<FetchUserData>((event, emit) async {
      try {
        final UserModel? UserData =
        await _firebaseService.getUserData(event.UserId);
        emit(UserDataLoaded(UserData!));
      } catch (error) {
        emit(UserDataError(error.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {

        emit(Loading());
        await FirebaseAuth.instance.signOut();
        emit(LoggedOutSuccess());

      } catch (error) {
        emit(UserDataError(error.toString()));
      }
    });

    on<DeleteUserEvent>((event, emit) async {
      emit(DeleteAccountLoading());
      await _firebaseService.deleteUserAndStoreDeleteUsersCollection();
      await FirebaseAuth.instance.signOut();
      emit(UserDeleteSuccess()); // Reset the state to loading state
    });
  }
}
