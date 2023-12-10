part of 'locale_bloc.dart';

sealed class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object> get props => [];
}

class LoadLanguage extends LocaleEvent {
  final Locale locale;

  const LoadLanguage({required this.locale});
}
