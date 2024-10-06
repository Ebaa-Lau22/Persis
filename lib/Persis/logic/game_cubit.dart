import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Persis/Persis/logic/game_states.dart';
import 'package:Persis/Persis/structure/board.dart';
import 'package:Persis/Persis/structure/constants.dart';
import 'package:Persis/Persis/structure/player.dart';
import '../structure/move.dart';
import '../structure/state.dart';
import '../structure/throw.dart';
import '../structure/tile_state.dart';
import '../style/colors.dart';

class GameCubit extends Cubit<GameStates> {
  GameCubit() : super(InitialGameState());

  static GameCubit get(context) => BlocProvider.of(context);

  ///////
  int selectedTile = 0;
  void updateSelected(index){
    selectedTile = index;
    emit(WinningState());
  }
  Text? selectedText;
  void changeText(Text? t){
    selectedText = t;
    emit(UpdateBoardState());
  }
  int selectedPage = 1;
  void changeEmpTablePage(int page){
    selectedPage = page;
    emit(ChangePageState());
  }

  bool empTableRightClickHovered = false;
  bool empTableLeftClickHovered = false;
  void hoverClick(int direction){
    if(direction == -1) empTableLeftClickHovered = true;
    else empTableRightClickHovered = true;
    emit(HoverState());
  }
  void cancelHoverClick(int direction){
    if(direction == -1) empTableLeftClickHovered = false;
    else empTableRightClickHovered = false;
    emit(HoverState());
  }
  //emit(WinningState);
  //emit(PerformBotMoveState);

  ///////

  Player player1 = Player(
      isPlayer2: false,
      name: 'فريال',
      isBot: false,
      playerPicture: "assets/images/firyal.jpg");
  Player player2 = Player(
      isPlayer2: true,
      name: 'أم زكي',
      isBot: true,
      playerPicture: "assets/images/om_ziki.jpg");

  /*
  currentState 0: the player didn't throw yet
  currentState 1: the player throw but didn't choose what rock to move
  currentState 2: the player throw and chose what rock to move but didn't select where to move to
  currentState 3: the player throw and chose what rock to move and where it moves
  */
  int currentState = 0;


  late Player currentTurnPlayer = player1;
  late Player otherPlayer = player2;
  late Player winningPlayer;

  bool isPlayer2Bot = true;
  bool isPlayer1Firyal = true;

  void changeGamePlay(bool gamePlay){
    isPlayer2Bot = gamePlay;
    emit(ChangeGamePlayState());
  }

  void changePlayer1(bool p1){
    isPlayer1Firyal = p1;
    emit(ChangeGamePlayState());
  }

  late List<int> chosenRocksIndex = [];
  int chosenBoardIndex = 0;
  bool rockPressed = false;

  int reThrow = 0;
  double currentEvaluation = 0.1;

  // يهيئ القيم الابتدائية
  void init() {

    if(isPlayer2Bot){
      if(isPlayer1Firyal){
        player2 = Player(
            isPlayer2: true,
            name: 'أم زكي',
            isBot: true,
            playerPicture: "assets/images/om_ziki.jpg");
      }
      else{
        player2 = Player(
            isPlayer2: true,
            name: 'فريال',
            isBot: true,
            playerPicture: "assets/images/firyal.jpg");
      }
    }
    else{
      if(isPlayer1Firyal){
        player2 = Player(
            isPlayer2: true,
            name: 'أم زكي',
            isBot: false,
            playerPicture: "assets/images/om_ziki.jpg");
      }
      else{
        player2 = Player(
            isPlayer2: true,
            name: 'فريال',
            isBot: false,
            playerPicture: "assets/images/firyal.jpg");
      }
    }

    if(isPlayer1Firyal){
      player1 = Player(
          isPlayer2: false,
          name: 'فريال',
          isBot: false,
          playerPicture: "assets/images/firyal.jpg");
    }
    else{
      player1 = Player(
          isPlayer2: false,
          name: 'أم زكي',
          isBot: false,
          playerPicture: "assets/images/om_ziki.jpg");
    }

    player1.rocks = [0, 0, 0, 0];
    player2.rocks = [100, 100, 100, 100];
    currentTurnPlayer = player1;
    otherPlayer = player2;
    for(int i=0 ; i<26 ; i++){
      player1.throwMoves.availableTransitions[i] = 0;
      player2.throwMoves.availableTransitions[i] = 0;
    }
    Board.initSets();
    checkWinningState();
  }

  // يقلب الدور
  void changeTurn() {
    for (int i = 0; i < 26; i++) {
      currentTurnPlayer.throwMoves.availableTransitions[i] = 0;
    }
    reThrow = 0;
    Player temp;
    temp = currentTurnPlayer;
    currentTurnPlayer = otherPlayer;
    otherPlayer = temp;
    currentState = 0;
    emit(ChangeTurnState());
  }

  late Throw currentThrow;
  List<bool> currentShells = [];
  // رمي الصدف
  void throwShells() {
    int upShells = 0;
    Random random = Random();
    currentShells.clear();
    if (reThrow > rethrowMax) {
      upShells = random.nextInt(2) + 2;
      int counter = 0;
      for(int i=0 ; i<6 ; i++){
        if(counter < upShells) {
          currentShells.add(true);
        } else{
          currentShells.add(false);
        }
        counter++;
      }
    }
    else{
      reThrow++;
      for (int i = 0; i < 6; i++) {
        currentShells.add(random.nextDouble() <= 0.45);
        if (currentShells[i] == true) upShells++;
      }
    }

    currentThrow = Throw.getThrow(upShells);

    if (currentThrow.khal) currentTurnPlayer.throwMoves.availableTransitions[1]++;
    currentTurnPlayer.throwMoves.availableTransitions[currentThrow.steps]++;

    if (!currentThrow.throwAgain) {
      currentState = 1;
      currentTurnPlayer.updateAvailableMovesForThrow(otherPlayer);
      if (currentTurnPlayer.throwMoves.availableRocks.isNotEmpty) {
        if(currentTurnPlayer.isBot){
          startBotTurn();
        }
        emit(PerformThrowState());
      }
      else {
        emit(NoMoveAvailable());
      }
    }
    else {
      currentState = 1;
      currentTurnPlayer.updateAvailableMovesForThrow(otherPlayer);
      emit(ThrowAgainState());
    }
  }

  void throwAgain() {
    currentState = 0;
    if(currentTurnPlayer == player2 && currentTurnPlayer.isBot){
      throwShells();
    }
    emit(PerformThrowState());
  }

  void performMove({
    required Move move,
  }) {
    {
      if (move.kill) {
        int otherIndex = Board.getOtherPlayerIndexForTile(move.toPos, otherPlayer.isPlayer2);
        for (int i = 0; i < 4; i++) {
          if (otherPlayer.rocks[i] == otherIndex ||
              (otherPlayer.rocks[i] == 176 && otherIndex == 108) ||
              (otherPlayer.rocks[i] == 76 && otherIndex == 8)) {
            if (otherPlayer.isPlayer2) {
              otherPlayer.rocks[i] = 100;
            } else {
              otherPlayer.rocks[i] = 0;
            }
          }
        }
      }

      currentTurnPlayer.rocks[move.rockIndex] = move.toPos;
      currentTurnPlayer.throwMoves.availableTransitions[move.toPos - move.fromPos]--;
      currentTurnPlayer.updateAvailableMovesForThrow(otherPlayer);

      checkWinningState();

      int sum = 0;
      for (int i in currentTurnPlayer.throwMoves.availableTransitions) {
        sum += i;
      }
      if (sum != 0) {
        currentState == 0;
        emit(InBetweenStates());
      } else {
        changeTurn();
      }
    }
  }

  void continueOtherMove() {
    if (currentTurnPlayer.throwMoves.availableRocks.isEmpty) {
      changeTurn();
    } else {
      emit(PerformMoveState());
    }
  }

  void chooseRockToMove(int index) {
    int currentIndex = Board.getCurrentPlayerIndexForTile(index, currentTurnPlayer.isPlayer2);
    int sameTileIndex = Board.getSecondIndexForTile(currentIndex);
    chosenBoardIndex = index;
    for (int i = 0; i < 4; i++) {
      if (currentTurnPlayer.rocks[i] == currentIndex) {
        chosenRocksIndex.add(i);
      }
      if (currentTurnPlayer.rocks[i] == sameTileIndex) {
        chosenRocksIndex.add(i);
      }
    }
    currentState = 2;
    emit(RockChosenState());
  }

  void cancelRockChosen() {
    chosenRocksIndex.clear();
    currentState = 1;
    emit(RockCancellationState());
  }

  Move? chooseTileToMoveTo(int index) {
    int currentIndex = Board.getCurrentPlayerIndexForTile(index, currentTurnPlayer.isPlayer2);
    int sameTileIndex = Board.getSecondIndexForTile(currentIndex);
    for (int begin in chosenRocksIndex) {
      for (Move move in currentTurnPlayer.throwMoves.availableMoves[begin]) {
        if (move.toPos == currentIndex || move.toPos == sameTileIndex) {
          return move;
        }
      }
    }
    return null;
  }

  int getTileState(int index, GameStates state) {
    if(state is ThrowAgainState) return TileState.notEffected;
    if (index == -1 || index == -2) return TileState.notEffected;
    if (currentState == 0) return TileState.notEffected;
    if (currentState == 1) {
      if (index >= 1000 && index < 1004) {
        if (currentTurnPlayer.rocks[index - 1000] != 0) {
          return TileState.notEffected;
        }
      }
      if (index >= 2000 && index < 2004) {
        if (currentTurnPlayer.rocks[index - 2000] != 100) {
          return TileState.notEffected;
        }
      }
      int indexInPlayerRocks = Board.getCurrentPlayerIndexForTile(
          index, currentTurnPlayer.isPlayer2);
      if (indexInPlayerRocks == -1) return TileState.notEffected;
      int otherIndexForSameTile =
          Board.getSecondIndexForTile(indexInPlayerRocks);
      for (int rockIndex in currentTurnPlayer.throwMoves.availableRocks) {
        if (indexInPlayerRocks == currentTurnPlayer.rocks[rockIndex]) {
          return TileState.canMoveFrom;
        }
        if (otherIndexForSameTile == currentTurnPlayer.rocks[rockIndex]) {
          return TileState.canMoveFrom;
        }
      }
    }
    if (currentState == 2) {
      if (index >= 1000 && index < 1004) {
        if (currentTurnPlayer.rocks[index - 1000] != 0) {
          return TileState.notEffected;
        }
      }
      if (index >= 2000 && index < 2004) {
        if (currentTurnPlayer.rocks[index - 2000] != 100) {
          return TileState.notEffected;
        }
      }
      if (index == chosenBoardIndex) {
        return TileState.canMoveFrom;
      }
      int indexInPlayerRocks = Board.getCurrentPlayerIndexForTile(
          index, currentTurnPlayer.isPlayer2);
      if (indexInPlayerRocks == -1) return TileState.notEffected;
      int otherIndexForSameTile =
          Board.getSecondIndexForTile(indexInPlayerRocks);
      for (int chosenRock in chosenRocksIndex) {
        for (Move move
            in currentTurnPlayer.throwMoves.availableMoves[chosenRock]) {
          if (indexInPlayerRocks == move.toPos) return TileState.canMoveTo;
          if (otherIndexForSameTile == move.toPos) return TileState.canMoveTo;
        }
      }
    }
    return TileState.notEffected;
  }

  List<Widget> drawBoard(double tileSide, GameStates state) {
    List<Widget> rows = [];
    for (int i = 0; i < 19; i++) {
      rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: drawRow(i, tileSide, state)));
    }
    return rows;
  }

  List<Widget> drawRow(int rowIndex, double tileSide, GameStates state) {
    List<Widget> row = [];
    for (int i = 0; i < 19; i++) {
      int value = Board.board[rowIndex][i];
      int tileState = getTileState(value, state);
      Widget finalTileWidget = Container();
      if (tileState == TileState.notEffected) {
        finalTileWidget = Board.getTileImage(player1, player2, value, tileSide);
      } else if (tileState == TileState.canMoveFrom) {
        finalTileWidget = GestureDetector(
          onTap: () {
            /*cancelRockChosen();
            chooseRockToMove(value);*/
            if (!rockPressed) {
              rockPressed = !rockPressed;
              chooseRockToMove(value);
            } else {
              rockPressed = !rockPressed;
              cancelRockChosen();
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Board.getTileImage(player1, player2, value, tileSide),
              Container(
                width: tileSide,
                height: tileSide,
                decoration: BoxDecoration(
                  color: red.withOpacity(0),
                  border: Border.all(width: 3, color: red),
                ),
              ),
            ],
          ),
        );
      } else if (tileState == TileState.canMoveTo) {
        finalTileWidget = GestureDetector(
          onTap: () {
            Move? move = chooseTileToMoveTo(value);
            performMove(move: move!);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Board.getTileImage(player1, player2, value, tileSide),
              Container(
                width: tileSide,
                height: tileSide,
                decoration: BoxDecoration(
                  color: gold.withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      }
      row.add(finalTileWidget);
    }
    return row;
  }

  List<Widget> drawPlayerTransitions() {
    List<Widget> transitions = [];
    for (int i=0 ; i<transitionsIndices.length ; i++) {
      if (currentTurnPlayer.throwMoves.availableTransitions[transitionsIndices[i]] != 0) {
        transitions.add(
          CircleAvatar(
            backgroundColor: red,
            radius: 18,
            child: CircleAvatar(
              backgroundColor: gold,
              radius: 17,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    transitionsNames[i],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    '${currentTurnPlayer.throwMoves.availableTransitions[transitionsIndices[i]]}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        transitions.add(
          const SizedBox(width: 5,),
        );
      }
    }
    return transitions;
  }

  Widget getCenterImage(double tileSide) {
    int state = getTileState(84, PerformThrowState());
    int player1FinalRocks = 0;
    int player2FinalRocks = 0;
    for (int i = 0; i < 4; i++) {
      if (player1.rocks[i] == 84) player1FinalRocks++;
      if (player2.rocks[i] == 184) player2FinalRocks++;
    }
    Widget centerWidget = Image(
      image: const AssetImage('assets/images/empty_tile.png'),
      height: tileSide * 2.45,
      width: tileSide * 2.45,
    );
    for (double i = 0; i < player2FinalRocks; i++) {
      centerWidget = Stack(
        alignment: Alignment.centerRight,
        children: [
          centerWidget,
          Transform.translate(
            offset: Offset(-(5.5 * i), -9),
            child: const Image(
              image: AssetImage('assets/images/c.png'),
              height: 20,
              width: 20,
            ),
          )
        ],
      );
    }
    for (double i = 0; i < player1FinalRocks; i++) {
      centerWidget = Stack(
        alignment: Alignment.centerLeft,
        children: [
          centerWidget,
          Transform.translate(
            offset: Offset((5.5 * i), 9),
            child: const Image(
              image: AssetImage('assets/images/p.png'),
              height: 20,
              width: 20,
            ),
          )
        ],
      );
    }
    if (state == TileState.canMoveTo) {
      return GestureDetector(
        onTap: () {
          Move? move = chooseTileToMoveTo(84);
          performMove(move: move!);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            centerWidget,
            Container(
              width: tileSide * 2.5,
              height: tileSide * 2.5,
              decoration: BoxDecoration(
                color: gold.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }
    return centerWidget;
  }

  double evaluate(BoardState st) {
    double evaluationP1 = 0.1;
    int wonP1 = 0;
    for (int pos in st.maxPlayer.rocks) {
      double rockPoints = 0.0;
      if (pos == 0) continue;
      rockPoints += 2;
      rockPoints += pos * 0.1;
      bool safe = false;
      for (int safeTile in Board.safeTilesPlayer1) {
        if (pos < safeTile) rockPoints += 0.2;
        if (pos == safeTile) {
          rockPoints += 2.5;
          safe = true;
          break;
        }
        if (pos >= safeTile) {
          break;
        }
      }
      if (safe) {
        evaluationP1 += rockPoints;
        continue;
      }
      if (pos == 84) {
        wonP1++;
        rockPoints += 3;
        evaluationP1 += rockPoints;
        continue;
      }
      if (pos < 8 || pos > 76) {
        evaluationP1 += rockPoints;
        continue;
      }
      List<int> distances = st.maxPlayer.getDistancesFromRock(index: pos, other: st.minPlayer);
      int tileCounter = 0;
      int percentage = 0;
      for (int tmp in st.maxPlayer.rocks) {
        if (tmp == pos) tileCounter++;
      }
      for (int d in distances) {
        if (Board.oneMoveDanger.contains(d)) {
          if (percentage == 0 && tileCounter < 2) {
            percentage = 50;
          }
          else if (percentage == 0 && tileCounter >= 2) {
            percentage = 75;
          } else if (percentage > 0) {
            percentage += 5;
          }
        }
        if (Board.twoMoveDanger.contains(d)) {
          if (percentage == 0 && tileCounter < 2) {
            percentage = 25;
          } else if (percentage == 0 && tileCounter >= 2) {
            percentage = 40;
          } else if (percentage > 0) {
            percentage += 2;
          }
        }
      }
      if (percentage == 0) percentage = 7;
      rockPoints -= percentage * 0.01 * rockPoints;
      evaluationP1 += rockPoints;
    }
    double evaluationP2 = 0;
    int wonP2 = 0;
    for (int pos in st.minPlayer.rocks) {
      double rockPoints = 0.0;
      if (pos == 100) continue;
      rockPoints += 2;
      rockPoints += (pos-100) * 0.1;
      bool safe = false;
      for (int safeTile in Board.safeTilesPlayer2) {
        if (pos < safeTile) rockPoints += 0.2;
        if (pos == safeTile) {
          rockPoints += 2.5;
          safe = true;
          break;
        }
        if (pos >= safeTile) {
          break;
        }
      }
      if (safe) {
        evaluationP2 += rockPoints;
        continue;
      }
      if (pos == 184) {
        rockPoints += 3;
        evaluationP2 += rockPoints;
        wonP2++;
        continue;
      }
      if (pos < 108 || pos > 176) {
        evaluationP2 += rockPoints;
        continue;
      }
      List<int> distances = st.minPlayer.getDistancesFromRock(index: pos, other: st.maxPlayer);
      int tileCounter = 0;
      int percentage = 0;
      for (int tmp in st.minPlayer.rocks) {
        if (tmp == pos) tileCounter++;
      }
      for (int d in distances) {
        if (Board.oneMoveDanger.contains(d)) {
          if (percentage == 0 && tileCounter < 2) percentage = 50;
          if (percentage == 0 && tileCounter >= 2) percentage = 75;
          if (percentage > 0) percentage += 5;
        }
        if (Board.twoMoveDanger.contains(d)) {
          if (percentage == 0 && tileCounter < 2) percentage = 25;
          if (percentage == 0 && tileCounter >= 2) percentage = 40;
          if (percentage > 0) percentage += 2;
        }
      }
      if (percentage == 0) percentage = 7;
      rockPoints -= percentage * 0.01 * rockPoints;
      evaluationP2 += rockPoints;
    }
    if(wonP1 == 4) return 50;
    if(wonP2 == 4) return -50;
    return evaluationP1 - evaluationP2;
  }

  void checkWinningState(){
    currentEvaluation = evaluate(BoardState(player1, player2, false));
    if(currentEvaluation >= 49){
      winningPlayer = player1;
    }
    else if(currentEvaluation <= -49){
      winningPlayer = player2;
    }
  }

  void moveBot(){
    if(botMoves.isNotEmpty){
      int i = botMoves.length-1;
      performMoveMinimax(move: botMoves[i], main: currentTurnPlayer, other: otherPlayer);
      botMoves.removeLast();
      checkWinningState();
      emit(WaitState());
    }
    else{
      changeTurn();
    }
  }

  void waitBeforeMove(){
    emit(BotMoveState());
  }

  int counter = 0;
  List<Move> botMoves = [];

  void startBotTurn(){
    currentTurnPlayer.updateAvailableMovesForThrow(otherPlayer);
    Player p1 = Player.copyPlayer(player1);
    Player p2 = Player.copyPlayer(player2);
    bool turn = false; // player 2 trun
    BoardState initState = BoardState(p1, p2, turn);
    EvaluatedMoves bestMoves = minValue(initState, 0, 0, -999, 999);
    botMoves.addAll(bestMoves.moves);

    emit(BotMoveState());
  }

  EvaluatedMoves minValue(BoardState st, int sameTurnCnt, int bothTurnsCnt, double alpha, double beta){
    counter++;
    String printingLine = '';
    if(bothTurnsCnt > minimaxDepth){
      EvaluatedMoves e = EvaluatedMoves();
      e.moves = [];
      e.evaluation = evaluate(st);
      printingLine = 'on Node number $counter MIN value was a leaf node with an evaluation of: ${e.evaluation}';
      //print(printingLine);
      return e;
    }

    int transitionsCnt = 0;
    for(int i in st.minPlayer.throwMoves.availableTransitions){
      transitionsCnt += i;
    }
    if(transitionsCnt == 0){
      BoardState stCopy = BoardState(Player.copyPlayer(st.maxPlayer), Player.copyPlayer(st.minPlayer), true);
      EvaluatedMoves em = chanceValue(stCopy, 0, bothTurnsCnt+1, alpha, beta);
      printingLine = 'on Node number $counter MIN value was a dead node with an evaluation of: ${em.evaluation}';
      //print(printingLine);
      return em;
    }

    EvaluatedMoves minMove = EvaluatedMoves();
    minMove.evaluation = 999;

    st.minPlayer.updateAvailableMovesForThrow(st.maxPlayer);
    if(st.minPlayer.throwMoves.availableRocks.isEmpty){
      for(int i=0 ; i<26 ; i++){
        st.minPlayer.throwMoves.availableTransitions[i] = 0;
      }
      BoardState stCopy = BoardState(Player.copyPlayer(st.maxPlayer), Player.copyPlayer(st.minPlayer), true);
      EvaluatedMoves em = chanceValue(stCopy, 0, bothTurnsCnt+1, alpha, beta);
      printingLine = 'on Node number $counter MIN value was a dead node with an evaluation of: ${em.evaluation}';
      //print(printingLine);
      return em;
    }
    printingLine = 'on Node number $counter MIN value is choosing from: ';
    for(int i in st.minPlayer.throwMoves.availableRocks){
      for(Move move in st.minPlayer.throwMoves.availableMoves[i]){
        BoardState stCopy = BoardState(Player.copyPlayer(st.maxPlayer), Player.copyPlayer(st.minPlayer), st.turn);
        performMoveMinimax(move: move, main: stCopy.minPlayer, other: stCopy.maxPlayer);
        EvaluatedMoves tmp = minValue(stCopy, sameTurnCnt, bothTurnsCnt, alpha, beta);
        printingLine = '$printingLine${tmp.evaluation}, ';
        if(tmp.evaluation <= minMove.evaluation){
          minMove.evaluation = tmp.evaluation;
          minMove.moves = [];
          minMove.moves.addAll(tmp.moves);
          minMove.moves.add(move);
        }
        beta = min(beta, minMove.evaluation);
        if(beta <= alpha) {
          break;
        }
      }
    }
    print(printingLine);
    print('Node chosen is: ${minMove.evaluation}');
    return minMove;
  }

  EvaluatedMoves maxValue(BoardState st, int sameTurnCnt, int bothTurnsCnt, double alpha, double beta){
    counter++;
    String printingLine = '';
    if(bothTurnsCnt > minimaxDepth){
      EvaluatedMoves e = EvaluatedMoves();
      e.moves = [];
      e.evaluation = evaluate(st);
      printingLine = 'on Node number $counter MAX value was a leaf node with an evaluation of: ${e.evaluation}';
      //print(printingLine);
      return e;
    }

    int transitionsCnt = 0;
    for(int i in st.maxPlayer.throwMoves.availableTransitions){
      transitionsCnt += i;
    }
    if(transitionsCnt == 0){
      BoardState stCopy = BoardState(Player.copyPlayer(st.maxPlayer), Player.copyPlayer(st.minPlayer), false);
      EvaluatedMoves em = chanceValue(stCopy, 1, bothTurnsCnt+1, alpha, beta);
      printingLine = 'on Node number $counter MAX value was a dead node with an evaluation of: ${em.evaluation}';
      //print(printingLine);
      return em;
    }

    EvaluatedMoves maxMove = EvaluatedMoves();
    maxMove.evaluation = -999;

    st.maxPlayer.updateAvailableMovesForThrow(st.minPlayer);

    st.maxPlayer.updateAvailableMovesForThrow(st.minPlayer);
    if(st.maxPlayer.throwMoves.availableRocks.isEmpty){
      for(int i=0 ; i<26 ; i++){
        st.maxPlayer.throwMoves.availableTransitions[i] = 0;
      }
      BoardState stCopy = BoardState(Player.copyPlayer(st.maxPlayer), Player.copyPlayer(st.minPlayer), false);
      EvaluatedMoves em = chanceValue(stCopy, 1, bothTurnsCnt+1, alpha, beta);
      printingLine = 'on Node number $counter MAX value was a dead node with an evaluation of: ${em.evaluation}';
      //print(printingLine);
      return em;
    }
    printingLine = 'on Node number $counter MAX value is choosing from: ';
    for(int i in st.maxPlayer.throwMoves.availableRocks){
      for(Move move in st.maxPlayer.throwMoves.availableMoves[i]){
        BoardState stCopy = BoardState(Player.copyPlayer(st.maxPlayer), Player.copyPlayer(st.minPlayer), st.turn);
        performMoveMinimax(move: move, main: stCopy.maxPlayer, other: stCopy.minPlayer);
        EvaluatedMoves tmp = maxValue(stCopy, sameTurnCnt, bothTurnsCnt, alpha, beta);
        printingLine = '$printingLine${tmp.evaluation}, ';
        if(tmp.evaluation >= maxMove.evaluation){
          maxMove.evaluation = tmp.evaluation;
          maxMove.moves = [];
          maxMove.moves.addAll(tmp.moves);
          maxMove.moves.add(move);
        }
        alpha = max(alpha, maxMove.evaluation);
        if(beta <= alpha) {
          break;
        }
      }
    }
    print(printingLine);
    print('Node chosen is: ${maxMove.evaluation}');
    return maxMove;
  }

  EvaluatedMoves chanceValue(BoardState st, int sameTurnCnt, int bothTurnsCnt, double alpha, double beta){
    counter++;
    if(sameTurnCnt > rethrowMax){
      if(st.turn) return maxValue(st, 0, bothTurnsCnt, alpha, beta);
      return minValue(st, 0, bothTurnsCnt, alpha, beta);
    }
    String printingLine = 'Node number $counter CHANCE value adding: \n';
    double eval = 0;
    for(int i=0 ; i<7 ; i++){
      Throw th = Throw.getThrow(i);
      BoardState stCopy = BoardState(Player.copyPlayer(st.maxPlayer), Player.copyPlayer(st.minPlayer), st.turn);
      if (th.khal) stCopy.minPlayer.throwMoves.availableTransitions[1]++;
      stCopy.minPlayer.throwMoves.availableTransitions[th.steps]++;
      if(th.throwAgain){
        EvaluatedMoves em = chanceValue(stCopy, sameTurnCnt + 1, bothTurnsCnt, alpha, beta);
        eval += em.evaluation * th.rate;
        printingLine = '$printingLine${th.name}{evaluation(${em.evaluation}) * chance(${th.rate})}\n';
      }
      else{
        if(stCopy.turn){
          EvaluatedMoves em = maxValue(stCopy, 0, bothTurnsCnt, alpha, beta);
          eval += em.evaluation * th.rate;
          printingLine = '$printingLine${th.name}{evaluation(${em.evaluation}) * chance(${th.rate})}\n';
        }else{
          EvaluatedMoves em = minValue(stCopy, 0, bothTurnsCnt, alpha, beta);
          eval += em.evaluation * th.rate;
          printingLine = '$printingLine${th.name}{evaluation(${em.evaluation}) * chance(${th.rate})}\n';
        }
      }
    }
    print(printingLine);
    EvaluatedMoves em = EvaluatedMoves();
    em.evaluation = eval;
    return em;

  }

  void performMoveMinimax({
    required Move move,
    required Player main,
    required Player other,
  }) {
      if (move.kill) {
        int otherIndex = Board.getOtherPlayerIndexForTile(move.toPos, other.isPlayer2);
        for (int i = 0; i < 4; i++) {
          if (other.rocks[i] == otherIndex ||
              (other.rocks[i] == 176 && otherIndex == 108) ||
              (other.rocks[i] == 76 && otherIndex == 8)) {
            if (other.isPlayer2) {
              other.rocks[i] = 100;
            } else {
              other.rocks[i] = 0;
            }
          }
        }
      }

      main.rocks[move.rockIndex] = move.toPos;
      main.throwMoves.availableTransitions[move.toPos - move.fromPos]--;
      main.updateAvailableMovesForThrow(other);

  }






/*  void startBotTurn() {
    throwShells();
    Player p1Copy = Player(
      name: player1.name,
      playerPicture: player1.playerPicture,
      isBot: player1.isBot,
      isPlayer2: player1.isPlayer2,
    );
    Player p2Copy = Player(
      name: player2.name,
      playerPicture: player2.playerPicture,
      isBot: player2.isBot,
      isPlayer2: player2.isPlayer2,
    );
    for (int i = 0; i < 4; i++) {
      p1Copy.rocks[i] = player1.rocks[i];
      p2Copy.rocks[i] = player2.rocks[i];
    }
    EvaluatedMoves bestMove = minValue(
        th: currentThrow,
        maxPlayer: p1Copy,
        minPlayer: p2Copy,
        counter: 0,
        lastMove: []);
  }

  EvaluatedMoves minValue(
      {required Throw th,
      required Player maxPlayer,
      required Player minPlayer,
      required int counter,
      required List<Move> lastMove}) {
    if (counter >= 10) {
      EvaluatedMoves e = EvaluatedMoves();
      e.moves = lastMove;
      e.evaluation = evaluate();
      return e;
    }

    minPlayer.updateAvailableMovesForThrow(th, maxPlayer);
    List<Move> currentMoves = [];
    for (List<Move> moves in minPlayer.throwMoves.availableMoves) {
      for (Move move in moves) {
        currentMoves.add(move);
      }
    }

    if (currentMoves.isEmpty) {
      EvaluatedMoves e = EvaluatedMoves();
      e.moves.addAll(lastMove);
      e.evaluation = evaluate();
      return e;
    }

    EvaluatedMoves minMoves = EvaluatedMoves();
    minMoves.moves.addAll(lastMove);
    minMoves.evaluation = 9999;

    for (Move firstMove in currentMoves) {
      Throw thCopy = Throw.getThrow(th.upShells);
      Player maxCopy = Player.copyPlayer(maxPlayer);
      Player minCopy = Player.copyPlayer(minPlayer);
      performMoveUtil(
          move: firstMove, cPlayer: minCopy, oPlayer: maxCopy, th: thCopy);
      minCopy.updateAvailableMovesForThrow(th, maxCopy);
      EvaluatedMoves chosenMoves = EvaluatedMoves();
      chosenMoves.moves.add(firstMove);
      List<Move> currentMovesInner = [];
      for (List<Move> moves in minCopy.throwMoves.availableMoves) {
        for (Move tmp in moves) {
          currentMovesInner.add(tmp);
        }
      }
      if (currentMovesInner.isNotEmpty) {
        for (Move secondMove in currentMovesInner) {
          chosenMoves.moves.add(secondMove);
          Player maxCopy2 = Player.copyPlayer(maxCopy);
          Player minCopy2 = Player.copyPlayer(minCopy);
          performMoveUtil(
              move: secondMove,
              cPlayer: minCopy2,
              oPlayer: maxCopy2,
              th: thCopy);
          for (int i = 0; i < 7; i++) {
            Throw newThrow = Throw.getThrow(i);
            if (newThrow.throwAgain) {
              EvaluatedMoves bestNextMove = minValue(
                th: newThrow,
                maxPlayer: maxCopy2,
                minPlayer: minCopy2,
                counter: counter + 1,
                lastMove: chosenMoves.moves,
              );
              chosenMoves.evaluation += newThrow.rate * bestNextMove.evaluation;
            } else {
              EvaluatedMoves worstNextMove = maxValue(
                th: newThrow,
                maxPlayer: maxCopy2,
                minPlayer: minCopy2,
                counter: counter + 1,
                lastMove: chosenMoves.moves,
              );
              chosenMoves.evaluation +=
                  newThrow.rate * worstNextMove.evaluation;
            }
            if (chosenMoves.evaluation < minMoves.evaluation) {
              minMoves = chosenMoves;
            }
          }
          chosenMoves.moves.remove(secondMove);
        }
      } else {
        for (int i = 0; i < 7; i++) {
          Throw newThrow = Throw.getThrow(i);
          if (newThrow.throwAgain) {
            EvaluatedMoves bestNextMove = minValue(
                th: newThrow,
                maxPlayer: maxCopy,
                minPlayer: minCopy,
                counter: counter + 1,
                lastMove: chosenMoves.moves);
            chosenMoves.evaluation += newThrow.rate * bestNextMove.evaluation;
          } else {
            EvaluatedMoves worstNextMove = maxValue(
                th: newThrow,
                maxPlayer: maxCopy,
                minPlayer: minCopy,
                counter: counter + 1,
                lastMove: chosenMoves.moves);
            chosenMoves.evaluation += newThrow.rate * worstNextMove.evaluation;
          }
          if (chosenMoves.evaluation < minMoves.evaluation) {
            minMoves = chosenMoves;
          }
        }
        chosenMoves.moves.remove(firstMove);
      }
    }

    return minMoves;
  }

  EvaluatedMoves maxValue(
      {required Throw th,
      required Player maxPlayer,
      required Player minPlayer,
      required int counter,
      required List<Move> lastMove}) {
    if (counter >= 10) {
      EvaluatedMoves e = EvaluatedMoves();
      e.moves = lastMove;
      e.evaluation = evaluate();
      return e;
    }

    maxPlayer.updateAvailableMovesForThrow(th, minPlayer);
    List<Move> currentMoves = [];
    for (List<Move> moves in maxPlayer.throwMoves.availableMoves) {
      for (Move move in moves) {
        currentMoves.add(move);
      }
    }

    if (currentMoves.isEmpty) {
      EvaluatedMoves e = EvaluatedMoves();
      e.moves = lastMove;
      e.evaluation = evaluate();
      return e;
    }

    EvaluatedMoves maxMoves = EvaluatedMoves();
    maxMoves.moves = lastMove;
    maxMoves.evaluation = -9999;

    for (Move move in currentMoves) {
      Throw thCopy = Throw.getThrow(th.upShells);
      Player maxCopy = Player.copyPlayer(maxPlayer);
      Player minCopy = Player.copyPlayer(minPlayer);
      performMoveUtil(
          move: move, cPlayer: maxCopy, oPlayer: minCopy, th: thCopy);
      EvaluatedMoves chosenMoves = EvaluatedMoves();
      chosenMoves.moves.add(move);
      List<Move> currentMovesInner = [];
      for (List<Move> moves in minCopy.throwMoves.availableMoves) {
        for (Move move in moves) {
          currentMovesInner.add(move);
        }
      }
      if (currentMovesInner.isNotEmpty) {
        for (Move move in currentMovesInner) {
          chosenMoves.moves.add(move);
          Player maxCopy2 = Player.copyPlayer(maxCopy);
          Player minCopy2 = Player.copyPlayer(minCopy);
          performMoveUtil(
              move: move, cPlayer: maxCopy2, oPlayer: minCopy2, th: thCopy);
          for (int i = 0; i < 7; i++) {
            Throw newThrow = Throw.getThrow(i);
            if (newThrow.throwAgain) {
              EvaluatedMoves bestNextMove = maxValue(
                th: newThrow,
                maxPlayer: maxCopy2,
                minPlayer: minCopy2,
                counter: counter + 1,
                lastMove: chosenMoves.moves,
              );
              chosenMoves.evaluation += newThrow.rate * bestNextMove.evaluation;
            } else {
              EvaluatedMoves worstNextMove = minValue(
                th: newThrow,
                maxPlayer: maxCopy2,
                minPlayer: minCopy2,
                counter: counter + 1,
                lastMove: chosenMoves.moves,
              );
              chosenMoves.evaluation +=
                  newThrow.rate * worstNextMove.evaluation;
            }
          }
          if (chosenMoves.evaluation > maxMoves.evaluation) {
            maxMoves = chosenMoves;
          }
        }
      } else {
        for (int i = 0; i < 7; i++) {
          Throw newThrow = Throw.getThrow(i);
          if (newThrow.throwAgain) {
            EvaluatedMoves bestNextMove = maxValue(
                th: newThrow,
                maxPlayer: maxCopy,
                minPlayer: minCopy,
                counter: counter + 1,
                lastMove: chosenMoves.moves);
            chosenMoves.evaluation += newThrow.rate * bestNextMove.evaluation;
          } else {
            EvaluatedMoves worstNextMove = minValue(
                th: newThrow,
                maxPlayer: maxCopy,
                minPlayer: minCopy,
                counter: counter + 1,
                lastMove: chosenMoves.moves);
            chosenMoves.evaluation += newThrow.rate * worstNextMove.evaluation;
          }
        }
        if (chosenMoves.evaluation > maxMoves.evaluation) {
          maxMoves = chosenMoves;
        }
      }
    }
    return maxMoves;
  }

  void performMoveUtil({
    required Move move,
    required Player cPlayer,
    required Player oPlayer,
    required Throw th,
  }) {
    if (!th.stepsDone && !th.khalDone) {
      if (move.toPos - move.fromPos == 1) {
        th.khalDone = true;
      } else {
        th.stepsDone = true;
      }
      if (!move.kill) {
        cPlayer.rocks[move.rockIndex] = move.toPos;
      } else {
        int otherIndex =
            Board.getOtherPlayerIndexForTile(move.toPos, oPlayer.isPlayer2);
        for (int i = 0; i < 4; i++) {
          if (oPlayer.rocks[i] == otherIndex) {
            if (oPlayer.isPlayer2) {
              oPlayer.rocks[i] = 100;
            } else {
              oPlayer.rocks[i] = 0;
            }
            break;
          }
        }
        cPlayer.rocks[move.rockIndex] = move.toPos;
      }
      cPlayer.updateAvailableMovesForThrow(th, oPlayer);
    } else {
      if (move.toPos - move.fromPos == 1) {
        th.khalDone = true;
      } else {
        th.stepsDone = true;
      }
      if (!move.kill) {
        cPlayer.rocks[move.rockIndex] = move.toPos;
      } else {
        cPlayer.rocks[move.rockIndex] = move.toPos;
        int otherIndex =
            Board.getOtherPlayerIndexForTile(move.toPos, cPlayer.isPlayer2);
        for (int pos in oPlayer.rocks) {
          if (pos == otherIndex) {
            if (oPlayer.isPlayer2) {
              oPlayer.rocks[otherIndex] = 100;
            } else {
              oPlayer.rocks[otherIndex] = 0;
            }
            break;
          }
        }
      }
    }
  }*/
}

class EvaluatedMoves {
  late List<Move> moves;
  late double evaluation;

  EvaluatedMoves() {
    moves = [];
    evaluation = 0.0;
  }
}
