class Move{
  final int rockIndex;
  final int fromPos;
  final int toPos;
  final bool kill;

  Move({required this.fromPos, required this.rockIndex, required this.toPos, required this.kill});

  @override
  String toString(){
    return 'Move: $fromPos to $toPos';
  }

}

class ThrowMoves {
  List<List<Move>> availableMoves = [[], [], [], []];
  List<int> availableRocks = [];
  List<int> availableTransitions = List.generate(26, (index) => 0);

  ThrowMoves();

  void addAvailableMove(Move move){
    if(!availableRocks.contains(move.rockIndex)) availableRocks.add(move.rockIndex);
    availableMoves[move.rockIndex].add(move);
  }
}