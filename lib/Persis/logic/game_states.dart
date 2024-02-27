abstract class GameStates {}

class InitialGameState extends GameStates {}

class PerformMoveState extends GameStates {}

class PerformThrowState extends GameStates {}

class ThrowAgainState extends GameStates {}

class ChangeTurnState extends GameStates {}

class RockChosenState extends GameStates {}

class NoMoveAvailable extends GameStates {}

class InBetweenStates extends GameStates {}

class RockCancellationState extends GameStates {}

class BotMoveState extends GameStates {}

class WinningState extends GameStates {}

class UpdateBoardState extends GameStates {}

class WaitState extends GameStates {}

class PerformBotMoveState extends GameStates {}

class ChangeGamePlayState extends GameStates {}

