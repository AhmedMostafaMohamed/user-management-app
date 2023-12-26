import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_management/data/models/user.dart';
import 'package:users_management/data/repositories/authentication/offline_authentication_repository.dart';
import 'package:users_management/data/repositories/user/offline_user_repository.dart';
import 'package:users_management/domain/blocs/auth/auth_bloc.dart';
import 'package:users_management/domain/blocs/locale/locale_bloc.dart';
import 'package:users_management/domain/blocs/user/user_bloc.dart';
import 'package:users_management/modules/user_details_page/user_details_page.dart';
import 'modules/auth/auth_page.dart';
import 'modules/home/home_page.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
  final String? token = await const FlutterSecureStorage().read(key: 'token');
  runApp(MyApp(
    token: token,
  ));
}

Future<String> getConfigForFirebase() async =>
    await rootBundle.loadString('assets/config/firebase_config.json');

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({
    super.key,
    this.token,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(userRepository: OfflineUserRepository()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: OfflineAuthenticationRepository(
                secureStorage: const FlutterSecureStorage()),
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
            initialRoute: buildInitilRoute(token),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/auth':
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
            // home: buildHomeScreen(token),
          );
        },
      ),
    );
  }

  String buildInitilRoute(String? token) => token == null
      ? '/auth'
      : !JwtDecoder.isExpired(token)
          ? '/home'
          : '/auth';
}
