import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleInitial(locale: Locale('en'))) {
    on<LoadLanguage>(_onLoadLanguage);
  }

  FutureOr<void> _onLoadLanguage(LoadLanguage event, Emitter<LocaleState> emit) {
    emit(ChangedLocaleState(changedLocale: event.locale));
  }
}
