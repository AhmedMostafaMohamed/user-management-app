import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(Unauthenticated()) {
    on<SignInEvent>(_onSignInEvent);
    on<SignOutEvent>(_onSignOutEvent);
  }

  FutureOr<void> _onSignInEvent(
      SignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoadingAuthState());
      final response = await _authRepository.googleSignInUser();
      response.fold(
          (errorMessage) => emit(UserErrorState(
                errorMessage: errorMessage,
              )),
          (user) => emit(Authenticated()));
    } catch (e) {
      emit(UserErrorState(
        errorMessage: 'Error fetching users: $e',
      ));
    }
  }

  FutureOr<void> _onSignOutEvent(
      SignOutEvent event, Emitter<AuthState> emit) async {
    try {
      final response = await _authRepository.signOutUser();
      response.fold(
          (errorMessage) => emit(UserErrorState(
                errorMessage: errorMessage,
              )),
          (user) => emit(Unauthenticated()));
    } catch (e) {
      emit(UserErrorState(
        errorMessage: 'Error fetching users: $e',
      ));
    }
  }
}
