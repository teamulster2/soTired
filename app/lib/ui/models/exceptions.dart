class GameWrongStateException implements Exception{
  String errMsg() => 'Something went wrong with the game. You entered a wrong state. Please restart the application.';
}