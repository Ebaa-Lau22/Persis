import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Persis/Persis/logic/game_cubit.dart';
import 'package:Persis/Persis/logic/game_states.dart';
import '../structure/constants.dart';
import '../style/colors.dart';
import 'home_screen.dart';

class WinningScreen extends StatelessWidget {
  const WinningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameStates>(
      listener: (context, state) {},
      builder: (context, state){
        var cubit = GameCubit.get(context);
        return Scaffold(
          backgroundColor: darkColor,
          appBar: AppBar(
            backgroundColor: darkColor,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ألف مبرووك ${cubit.winningPlayer.name}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 40,),
                  Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                            color: red,
                          ),
                        ),
                        ClipRRect(
                          borderRadius:
                          const BorderRadius.all(
                              Radius.circular(14)),
                          child: Container(
                            width: 200,
                            height: 200,
                            color: darkColor,
                            child: Image(
                              image: AssetImage(cubit.winningPlayer.playerPicture),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ]),
                  const SizedBox(height: 80,),
                  SizedBox(
                    height: 50,
                    width: 160,
                    child: ClipRRect(
                      borderRadius:
                      const BorderRadiusDirectional.all(
                          Radius.circular(20)),
                      child: defaultButton(
                        onPressed: () {
                          cubit.init();
                          navigateAndFinish(context, const HomeScreen());
                        },
                        text: 'إعادة اللعبة',
                        textColor: Colors.white,
                        buttonColor: red,
                        borderRadius: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
