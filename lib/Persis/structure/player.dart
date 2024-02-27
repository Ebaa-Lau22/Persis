import 'package:Persis/Persis/structure/move.dart';
import 'board.dart';
import 'constants.dart';

class Player {
  final String name;
  final bool isPlayer2;
  final bool isBot;
  List<int> rocks = [];
  final String playerPicture;
  ThrowMoves throwMoves = ThrowMoves();

  Player(
      {required this.name,
      required this.isPlayer2,
      required this.isBot,
      required this.playerPicture}) {
    if (isPlayer2) {
      rocks = [150, 182, 115, 184];
    } else {
      rocks = [20, 60, 3, 0];
    }
  }

  static Player copyPlayer(Player p){
    Player copy = Player(name: p.name, isBot: p.isBot, isPlayer2: p.isPlayer2, playerPicture: p.playerPicture);
    for(int i=0 ; i<4 ; i++){
      copy.rocks[i] = p.rocks[i];
    }
    for(int i=0 ; i<p.throwMoves.availableTransitions.length ; i++){
      copy.throwMoves.availableTransitions[i] = p.throwMoves.availableTransitions[i];
    }
    for(int index in p.throwMoves.availableRocks){
      copy.throwMoves.availableRocks.add(index);
      copy.throwMoves.availableMoves[index].addAll(p.throwMoves.availableMoves[index]);
    }
    return copy;
  }

  void updateAvailableMovesForThrow(Player otherPlayer) {
    throwMoves.availableRocks.clear();
    for(int i=0; i<4; i++) {
      throwMoves.availableMoves[i].clear();
    }
    for(int i=0 ; i<4 ; i++){
      if(rocks[i] == 84 || rocks[i] == 184) continue;
      for(int transition in transitionsIndices){
        if(throwMoves.availableTransitions[transition] == 0) continue;
        int destination = rocks[i] + transition;
        if ((destination > 84 && !isPlayer2) || destination > 184) continue;

        if(rocks[i] == 0 || rocks[i] == 100) {
          if(transition == 1){
            throwMoves.addAvailableMove(Move(rockIndex: i, fromPos: rocks[i], toPos: rocks[i]+1, kill: false));
          }
          break;
        }

        int otherPlayerDest = Board.getOtherPlayerIndexForTile(destination, otherPlayer.isPlayer2);
        int otherPlayerDestCounter = 0;
        bool isSafe;
        if(otherPlayer.isPlayer2){
          isSafe = Board.safeTilesPlayer2.contains(otherPlayerDest);
        } else{
          isSafe = Board.safeTilesPlayer1.contains(otherPlayerDest);
        }

        for (int pos in otherPlayer.rocks) {
          if ((pos == otherPlayerDest ||
              (pos == 176 && otherPlayerDest == 108) ||
              (pos == 76 && otherPlayerDest == 8))) {
            otherPlayerDestCounter++;
            break;
          }
        }

        if(otherPlayerDestCounter == 0){
          throwMoves.addAvailableMove(Move(
            rockIndex: i,
            fromPos: rocks[i],
            toPos: destination,
            kill: false,
          ));
        }
        else if(!isSafe){
          throwMoves.addAvailableMove(Move(
            rockIndex: i,
            fromPos: rocks[i],
            toPos: destination,
            kill: true,
          ));
        }
      }
    }
  }

  List<int> getDistancesFromRock({required int index, required Player other}) {
    List<int> distances = [];
    if (other.isPlayer2) {
      for (int rock in other.rocks) {
        if(rock == 100) {
          distances.add(1000);
          continue;
        }
        if (index == 42 && rock > 108) {
          distances.add(index + 134 - rock);
          continue;
        }
        if (index >= 42) {
          distances.add(index + 66 - rock);
        }
        else {
          distances.add(index + 134 - rock);
        }
      }
    } else {
      for (int rock in other.rocks) {
        if(rock == 0) {
          distances.add(1000);
          continue;
        }
        if (index == 142 && rock > 8) {
          distances.add(index - 66 - rock);
        }
        if (index >= 142) {
          distances.add(index - 134 - rock);
        } else {
          distances.add(index - 66 - rock);
        }
      }
    }
    return distances;
  }
}
