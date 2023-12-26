import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/blocs/auth/auth_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      loginProviders: [
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: AppLocalizations.of(context)!.google,
          callback: () async {
            final userBloc = BlocProvider.of<AuthBloc>(context);
            try {
              // Dispatch the SignInUser event to the authentication Bloc
              userBloc.add(SignInEvent());

              await for (final state in userBloc.stream) {
                if (state is UserErrorState) {
                  return state.errorMessage;
                } else if (state is Authenticated) {
                  return null;
                }
              }
            } on FirebaseAuthException catch (e) {
              debugPrint('errors: $e');
              return e.message;
            }

            return null;
          },
        ),
      ],
      onLogin: (LoginData data) async {
        final userBloc = BlocProvider.of<AuthBloc>(context);
        try {
          // Dispatch the SignInUser event to the authentication Bloc
          userBloc.add(EmailPasswordSignInEvent(
              email: data.name, password: data.password));

          await for (final state in userBloc.stream) {
            if (state is UserErrorState) {
              return state.errorMessage;
            } else if (state is Authenticated) {
              return null;
            }
          }
        }  catch (e) {
          debugPrint('errors: $e');
          return e.toString();
        }

        return null;
      },
      onRecoverPassword: (p0) {
        return null;
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
    );
  }
}
