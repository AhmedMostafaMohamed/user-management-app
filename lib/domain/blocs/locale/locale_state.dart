part of 'locale_bloc.dart';

sealed class LocaleState extends Equatable {
  final Locale locale;
  const LocaleState({required this.locale});

  @override
  List<Object> get props => [locale];
}

final class LocaleInitial extends LocaleState {
  const LocaleInitial({required super.locale});
}

final class ChangedLocaleState extends LocaleState {
  final Locale changedLocale;
  const ChangedLocaleState({required this.changedLocale})
      : super(locale: changedLocale);
}
