import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Persis/Persis/modules/home_screen.dart';
import 'Persis/logic/game_cubit.dart';
import 'Persis/logic/game_states.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocProvider(
      create: (context) => GameCubit()..init(),
      child: BlocConsumer<GameCubit, GameStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Easter Sokoban',
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            locale: const Locale('ar'),
            theme: ThemeData(
              primarySwatch: Colors.amber,
            ),

            home: const HomeScreen(),
          );
        },
      )
    );
  }
}
