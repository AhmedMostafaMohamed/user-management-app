import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:users_management/data/models/user.dart';
import 'package:users_management/data/repositories/user/base_user_repository.dart';


part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final BaseUserRepository _userRepository;
  UserBloc({required BaseUserRepository userRepository})
      : _userRepository = userRepository,
        super(UserInitial()) {
    on<FetchUsersEvent>(_onFetchInvoicesEvent);
    on<AddUserEvent>(_onAddUserEvent);
    on<UpdateUserEvent>(_onUpdateUserEvent);
    on<DeleteUserEvent>(_onDeleteUserEvent);
  }

  FutureOr<void> _onFetchInvoicesEvent(
      FetchUsersEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingState());
      final response = await _userRepository.getAllUsers();
      response.fold(
          (errorMessage) => emit(ErrorState(errorMessage: errorMessage)),
          (users) => emit(LoadedState(users: users)));
    } catch (e) {
      emit(ErrorState(errorMessage: '$e'));
    }
  }

  FutureOr<void> _onAddUserEvent(
      AddUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingState());
      final response = await _userRepository.addUser(event.user, event.password);
      response.fold(
          (errorMessage) => emit(ErrorState(errorMessage: errorMessage)),
          (user) => emit(UserAddedState()));
      add(FetchUsersEvent());
    } catch (e) {
      emit(ErrorState(errorMessage: '$e'));
    }
  }

  FutureOr<void> _onUpdateUserEvent(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingState());
      final response = await _userRepository.updateUser(event.user);

      response.fold(
          (errorMessage) => emit(ErrorState(errorMessage: errorMessage)),
          (user) => emit(UserUpdatedState()));
      add(FetchUsersEvent());
    } catch (e) {
      emit(ErrorState(errorMessage: '$e'));
    }
  }

  FutureOr<void> _onDeleteUserEvent(
      DeleteUserEvent event, Emitter<UserState> emit) async {
    try {
      emit(LoadingState());
      final response = await _userRepository.deleteUser(event.userId);
      response.fold(
          (errorMessage) => emit(ErrorState(errorMessage: errorMessage)),
          (user) => emit(UserDeletedState()));
      add(FetchUsersEvent());
    } catch (e) {
      emit(ErrorState(errorMessage: '$e'));
    }
  }
}
