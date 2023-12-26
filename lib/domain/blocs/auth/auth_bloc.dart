import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:users_management/data/repositories/authentication/base_authentication_repository.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final BaseAuthRepository _authRepository;
  AuthBloc({
    required BaseAuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(Unauthenticated()) {
    on<SignInEvent>(_onSignInEvent);
    on<SignOutEvent>(_onSignOutEvent);
    on<EmailPasswordSignInEvent>(_onEmailPasswordSignInEvent);
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

  FutureOr<void> _onEmailPasswordSignInEvent(
      EmailPasswordSignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(LoadingAuthState());
      final response = await _authRepository.emailPasswordSignIn(
          event.email, event.password);
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
}
