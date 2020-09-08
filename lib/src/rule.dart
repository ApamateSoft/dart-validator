import 'Functions.dart';

class Rule {
  Rule(this._message, this._validate);

  final String _message;
  final Validate _validate;

  bool isValid(String evaluate) {
    return _validate(evaluate);
  }

  String getMessage() {
    return _message;
  }

}