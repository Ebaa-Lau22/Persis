import '../../manican/lib/features/employees/presentation/pages/add_employee_screen.dart';
import 'package:Persis/manican/home_screen.dart';
import 'package:Persis/manican/login_screen.dart';
import 'package:Persis/manican/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Persis/Persis/modules/home_screen.dart';
import 'Persis/logic/game_cubit.dart';
import 'Persis/logic/game_states.dart';
import 'manican/cubit.dart';

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
      //create: (context) => GameCubit()..init(),
      create: (context) => AppCubit(),
      child: BlocConsumer</*GameCubit, GameStates*/AppCubit, AppStates>(
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
            locale: const Locale('en'),
            theme: ThemeData(
              primarySwatch: Colors.amber,
            ),

            home: const AddEmployeeScreen(),
          );
        },
      )
    );
  }
}
