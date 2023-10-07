class WrongCredentials implements Exception {
  final String message;
  
  WrongCredentials(this.message);
}

class InvalidToken implements Exception {}

class ConectionTimeout implements Exception {}

class CustomError implements Exception {
  final String message;
  /*
    =Ejemplo si queremos más adelante guardar logs=

    final bool loggedRequired;
    CustomError(this.message, [this.loggedRequired = false]);
  */
  CustomError(this.message);
}
