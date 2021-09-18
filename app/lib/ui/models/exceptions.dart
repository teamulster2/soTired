/// This class is designed to send a GameWrontState-Exception when the spatial span task enters a wrong state, that is not defined.
class GameWrongStateException implements Exception {
  String errMsg() =>
      'Something went wrong with the game. You entered a wrong state. Please restart the application.';
}
