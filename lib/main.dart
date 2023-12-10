import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:users_management/data/models/user.dart';
import 'package:users_management/data/repositories/authentication/authentication_repository.dart';
import 'package:users_management/data/repositories/user/user_repository.dart';
import 'package:users_management/domain/blocs/auth/auth_bloc.dart';
import 'package:users_management/domain/blocs/locale/locale_bloc.dart';
import 'package:users_management/domain/blocs/user/user_bloc.dart';
import 'package:users_management/modules/user_details_page/user_details_page.dart';
import 'modules/auth/auth_page.dart';
import 'modules/home/home_page.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String jsonString = await getConfigForFirebase();
  Map configMap = json.decode(jsonString);
  Map authProjectConfig = configMap['auth_firebase_config'];

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: authProjectConfig['apiKey'],
        authDomain: authProjectConfig['authDomain'],
        projectId: authProjectConfig['projectId'],
        storageBucket: authProjectConfig['storageBucket'],
        messagingSenderId: authProjectConfig['messagingSenderId'],
        appId: authProjectConfig['appId']),
  );
  runApp(const MyApp());
}

Future<String> getConfigForFirebase() async =>
    await rootBundle.loadString('assets/config/firebase_config.json');

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(userRepository: UserRepository()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(googleSignIn: GoogleSignIn()),
          ),
        ),
        BlocProvider(create: (context) => LocaleBloc()),
      ],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Users mangement',
            locale: state.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                      builder: (context) => const AuthPage());
                case '/home':
                  return MaterialPageRoute(
                      builder: (context) => const HomePage());
                case '/user-details':
                  User user = settings.arguments as User;
                  return MaterialPageRoute(
                      builder: (context) => UserDetailsPage(
                            user: user,
                            isAddingNewUser: user.id == '0' ? true : false,
                          ));
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
