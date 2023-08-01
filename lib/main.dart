import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:users_management/data/models/user.dart';
import 'package:users_management/data/repositories/authentication/authentication_repository.dart';
import 'package:users_management/data/repositories/user/user_repository.dart';
import 'package:users_management/domain/blocs/auth/auth_bloc.dart';
import 'package:users_management/domain/blocs/user/user_bloc.dart';
import 'package:users_management/modules/user_details_page/user_details_page.dart';
import 'firebase_options.dart';
import 'modules/auth/auth_page.dart';
import 'modules/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

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
            authRepository: AuthRepository(),
          ),
        )
      ],
      child: MaterialApp(
        title: 'Users mangement',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => const AuthPage());
            case '/home':
              return MaterialPageRoute(builder: (context) => const HomePage());
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
      ),
    );
  }
}
