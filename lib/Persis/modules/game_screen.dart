import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Persis/Persis/logic/game_states.dart';
import 'package:Persis/Persis/modules/home_screen.dart';
import 'package:Persis/Persis/modules/winning_screen.dart';
import 'package:Persis/Persis/structure/constants.dart';
import 'package:Persis/Persis/style/colors.dart';
import '../logic/game_cubit.dart';
import 'info_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double tileSide = MediaQuery.of(context).size.width / 20;
    return BlocConsumer<GameCubit, GameStates>(
      listener: (context, state) {
        if (state is NoMoveAvailable) {
          Future.delayed(const Duration(seconds: 1, milliseconds: 200), () {
            GameCubit.get(context).changeTurn();
          });
        }
        if (state is InBetweenStates) {
          Future.delayed(const Duration(milliseconds: 500), () {
            GameCubit.get(context).continueOtherMove();
          });
          GameCubit.get(context).currentState = 1;
        }
        if (state is ThrowAgainState) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            GameCubit.get(context).throwAgain();
          });
        }
        if (state is ChangeTurnState && GameCubit.get(context).currentTurnPlayer.isBot) {
          Future.delayed(const Duration(milliseconds: 200), () {
            GameCubit.get(context).currentState = 1;
          });

          Future.delayed(const Duration(milliseconds: 800), () {
            GameCubit.get(context).throwShells();
          });
        }
        if (state is BotMoveState) {
          Future.delayed(const Duration(milliseconds: 1300), () {
            GameCubit.get(context).moveBot();
          });
        }
        if (state is WaitState){
          Future.delayed(const Duration(milliseconds: 500), () {
            GameCubit.get(context).waitBeforeMove();
          });
        }

      },

      builder: (context, state) {
        var cubit = GameCubit.get(context);
        if(cubit.currentEvaluation>=49 || cubit.currentEvaluation<=-49){
          return const WinningScreen();
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: darkColor,
            title: Center(
              child: Text(
                cubit.currentEvaluation.toStringAsFixed(3),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
                textDirection: TextDirection.ltr,
              ),
            ),
            leading: IconButton(
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (context){
                      return Dialog(
                        backgroundColor: darkColor,
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 200,
                              width: 300,
                              decoration: BoxDecoration(
                                color: red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Container(
                              height: 190,
                              width: 290,
                              decoration: BoxDecoration(
                                color: darkColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'متأكد بدك تطلع سيد راسي؟',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'لا والله',
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
                                          width: 40,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            navigateAndFinish(context, const HomeScreen());
                                          },
                                          child: Container(
                                            width: 100,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: red,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'بخاطركن',
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
                          ],
                        ),
                      );
                    },
                );
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: (){
                  navigateTo(context, const InfoScreen());
                },
                icon: const Icon(Icons.info_outlined, color: Colors.white,),),
              const SizedBox(width: 5,),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: gold,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      color: darkColor,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(78)),
                                    color: gold,
                                  ),
                                ),
                                Container(
                                  height: 106,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(74)),
                                    color: Colors.black,
                                  ),
                                  child: Row(
                                    children: [
                                      Stack(
                                          alignment: Alignment.centerRight,
                                          children: [
                                            Container(
                                              width: 120,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                                color: gold,
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(14)),
                                              child: Container(
                                                width: 116,
                                                height: 106,
                                                color: darkColor,
                                                child: Image(
                                                  image: AssetImage(cubit
                                                      .player2.playerPicture),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ]),
                                      const SizedBox(
                                        width: 45,
                                      ),
                                      if (cubit.currentTurnPlayer == cubit.player2 && cubit.currentState == 0 && !cubit.currentTurnPlayer.isBot)
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                cubit.throwShells();
                                              },
                                              child: Container(
                                                width: 71,
                                                height: 46,
                                                decoration: BoxDecoration(
                                                  color: red,
                                                  border: Border.all(
                                                      color: gold, width: 3),
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(
                                                          60)),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    'ارمِ الودع',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      else if (cubit.currentTurnPlayer == cubit.player2 && cubit.currentState != 0)
                                        Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                            angle: 30 * pi / 180,
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Image(
                                  image: cubit.currentShells[
                                  0]
                                      ? const AssetImage(
                                      'assets/images/up_shell.jpg')
                                      : const AssetImage(
                                      'assets/images/down_shell.jpg'),
                                  fit: BoxFit.fitHeight,
                                )),
                        ),
                        const SizedBox(
                            width: 5,
                        ),
                        Transform.rotate(
                            angle: 30 * pi / 180,
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Image(
                                  image: cubit.currentShells[
                                  1]
                                      ? const AssetImage(
                                      'assets/images/up_shell.jpg')
                                      : const AssetImage(
                                      'assets/images/down_shell.jpg'),
                                  fit: BoxFit.fitHeight,
                                )),
                        ),
                        const SizedBox(
                            width: 5,
                        ),
                        Transform.rotate(
                            angle: 30 * pi / 180,
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Image(
                                  image: cubit.currentShells[
                                  2]
                                      ? const AssetImage(
                                      'assets/images/up_shell.jpg')
                                      : const AssetImage(
                                      'assets/images/down_shell.jpg'),
                                  fit: BoxFit.fitHeight,
                                )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                            angle: 30 * pi / 180,
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Image(
                                  image: cubit.currentShells[
                                  3]
                                      ? const AssetImage(
                                      'assets/images/up_shell.jpg')
                                      : const AssetImage(
                                      'assets/images/down_shell.jpg'),
                                )),
                        ),
                        const SizedBox(
                            width: 5,
                        ),
                        Transform.rotate(
                            angle: 30 * pi / 180,
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Image(
                                  image: cubit.currentShells[
                                  4]
                                      ? const AssetImage(
                                      'assets/images/up_shell.jpg')
                                      : const AssetImage(
                                      'assets/images/down_shell.jpg'),
                                )),
                        ),
                        const SizedBox(
                            width: 5,
                        ),
                        Transform.rotate(
                            angle: 30 * pi / 180,
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Image(
                                  image: cubit.currentShells[
                                  5]
                                      ? const AssetImage(
                                      'assets/images/up_shell.jpg')
                                      : const AssetImage(
                                      'assets/images/down_shell.jpg'),
                                  fit: BoxFit.fitHeight,
                                )),
                        ),
                      ],
                    ),
                  ],
                )
                                      else const SizedBox(),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      if (cubit.currentTurnPlayer ==
                                              cubit.player2 &&
                                          cubit.currentState != 0)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              cubit.currentThrow.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${cubit.currentThrow.stepsText} ',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Stack(
                                alignment: cubit.currentTurnPlayer == cubit. player2 ? Alignment.topCenter : Alignment.bottomCenter,
                                children: [
                                  Transform.rotate(
                                    angle: -45 * pi / 180,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: cubit.drawBoard(tileSide, state),
                                        ),
                                        cubit.getCenterImage(tileSide),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: cubit.drawPlayerTransitions(),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(78)),
                                    color: gold,
                                  ),
                                ),
                                Container(
                                  height: 106,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(74)),
                                    color: Colors.black,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (cubit.currentTurnPlayer == cubit.player1 && cubit.currentState != 0)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              cubit.currentThrow.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '${cubit.currentThrow.stepsText} ',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ],
                                        ),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      if (cubit.currentTurnPlayer == cubit.player1 && cubit.currentState != 0)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Transform.rotate(
                                                  angle: 30 * pi / 180,
                                                  child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Image(
                                                        image: cubit
                                                                .currentShells[0]
                                                            ? const AssetImage(
                                                                'assets/images/up_shell.jpg')
                                                            : const AssetImage(
                                                                'assets/images/down_shell.jpg'),
                                                        fit: BoxFit.fitHeight,
                                                      )),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Transform.rotate(
                                                  angle: 30 * pi / 180,
                                                  child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Image(
                                                        image: cubit
                                                                .currentShells[1]
                                                            ? const AssetImage(
                                                                'assets/images/up_shell.jpg')
                                                            : const AssetImage(
                                                                'assets/images/down_shell.jpg'),
                                                        fit: BoxFit.fitHeight,
                                                      )),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Transform.rotate(
                                                  angle: 30 * pi / 180,
                                                  child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Image(
                                                        image: cubit
                                                                .currentShells[2]
                                                            ? const AssetImage(
                                                                'assets/images/up_shell.jpg')
                                                            : const AssetImage(
                                                                'assets/images/down_shell.jpg'),
                                                        fit: BoxFit.fitHeight,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Transform.rotate(
                                                  angle: 30 * pi / 180,
                                                  child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Image(
                                                        image: cubit
                                                                .currentShells[3]
                                                            ? const AssetImage(
                                                                'assets/images/up_shell.jpg')
                                                            : const AssetImage(
                                                                'assets/images/down_shell.jpg'),
                                                      )),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Transform.rotate(
                                                  angle: 30 * pi / 180,
                                                  child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Image(
                                                        image: cubit
                                                                .currentShells[4]
                                                            ? const AssetImage(
                                                                'assets/images/up_shell.jpg')
                                                            : const AssetImage(
                                                                'assets/images/down_shell.jpg'),
                                                      )),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Transform.rotate(
                                                  angle: 30 * pi / 180,
                                                  child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Image(
                                                        image: cubit
                                                                .currentShells[5]
                                                            ? const AssetImage(
                                                                'assets/images/up_shell.jpg')
                                                            : const AssetImage(
                                                                'assets/images/down_shell.jpg'),
                                                        fit: BoxFit.fitHeight,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      else if (cubit.currentTurnPlayer == cubit.player1 && cubit.currentState == 0)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                cubit.throwShells();
                                                //cubit.test();
                                              },
                                              child: Container(
                                                width: 71,
                                                height: 46,
                                                decoration: BoxDecoration(
                                                  color: red,
                                                  border: Border.all(
                                                      color: gold, width: 3),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(60)),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    'ارمِ الودع',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        const SizedBox(
                                          height: 20,
                                          width: 20,
                                        ),
                                      const SizedBox(
                                        width: 45,
                                      ),
                                      Stack(
                                          alignment: Alignment.centerLeft,
                                          children: [
                                            Container(
                                              width: 120,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                color: gold,
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(14)),
                                              child: Container(
                                                width: 116,
                                                height: 106,
                                                color: darkColor,
                                                child: Image(
                                                  image: AssetImage(
                                                      cubit.player1.playerPicture),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
