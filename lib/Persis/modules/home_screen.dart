import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Persis/Persis/modules/game_screen.dart';
import 'package:Persis/Persis/style/colors.dart';
import '../logic/game_cubit.dart';
import '../logic/game_states.dart';
import '../structure/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = GameCubit.get(context);
        return Scaffold(
          backgroundColor: darkColor,
          appBar: AppBar(
            backgroundColor: darkColor,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'شو بدك تلعب',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                cubit.changeGamePlay(false);
                              },
                              child: Container(
                                width: 100,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: !cubit.isPlayer2Bot ? gold : darkColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: Text(
                                    '2 ضد بعض',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            GestureDetector(
                              onTap: () {
                                cubit.changeGamePlay(true);
                              },
                              child: Container(
                                width: 100,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: cubit.isPlayer2Bot ? gold : darkColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: Text(
                                    'لحالك',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  height: 240,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'اختار اللاعب الأول',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                cubit.changePlayer1(true);
                              },
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: cubit.isPlayer1Firyal
                                        ? gold
                                        : darkColor,
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image(
                                            image: AssetImage(
                                                cubit.player1.playerPicture),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        if (cubit.isPlayer1Firyal)
                                          Container(
                                            height: 20,
                                            color: cubit.isPlayer1Firyal
                                                ? gold.withOpacity(0.6)
                                                : darkColor.withOpacity(0.3),
                                            child: Center(
                                                child: Text(
                                              cubit.player1.name,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                cubit.changePlayer1(false);
                              },
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: !cubit.isPlayer1Firyal
                                        ? gold
                                        : darkColor,
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(14)),
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image(
                                            image: AssetImage(
                                                cubit.player2.playerPicture),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        if (!cubit.isPlayer1Firyal)
                                          Container(
                                            height: 20,
                                            color: !cubit.isPlayer1Firyal
                                                ? gold.withOpacity(0.6)
                                                : darkColor.withOpacity(0.3),
                                            child: Center(
                                                child: Text(
                                              cubit.player2.name,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                  height: 50,
                  width: 150,
                  child: defaultButton(
                    onPressed: () {
                      cubit.init();
                      navigateAndFinish(context, GameScreen());
                    },
                    text: 'بلش لقلك',
                    textColor: Colors.white,
                    buttonColor: gold,
                    fontSize: 16,
                    borderRadius: 20,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
