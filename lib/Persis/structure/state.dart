import 'package:Persis/Persis/structure/player.dart';

class BoardState{
  late Player maxPlayer;
  late Player minPlayer;
  late bool turn; // true means p1 turn
  double evaluation = 0.0;

  BoardState(this.maxPlayer, this.minPlayer, this.turn);

}

