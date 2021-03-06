import 'src/messages.dart';
import 'src/functions.dart';
import 'src/rule.dart';

class Validator {

  static final _EMAIL_RE = RegExp(r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$");
  static var _messages = Messages();

  List<Rule> _rules = [];
  NotPass _notBeingValid;
  String _mismatchMessage = _messages.notMatch;

  Validator();

  Validator._(final this._rules, final this._notBeingValid);

  static void setMessages(Messages messages) {
    _messages = messages;
  }

  set mismatchMessage(String mismatchMessage) {
    _mismatchMessage = mismatchMessage;
  }

  bool isValid(String evaluate) {
    for (final rule in _rules) {
      if (!rule.isValid(evaluate)) {
        if (_notBeingValid!=null) _notBeingValid(rule.getMessage());
        return false;
      }
    }
    return true;
  }

  bool compare(String evaluate, String compare) {
    if (evaluate==null || compare==null) {
      if (_notBeingValid!=null) _notBeingValid(_mismatchMessage);
      return false;
    }
    if (evaluate!=compare) {
      if (_notBeingValid!=null) _notBeingValid(_mismatchMessage);
      return false;
    }
    return isValid(evaluate);
  }

  Validator rule(String message, Validate validate) {
    _rules.add(Rule(message, validate));
    return this;
  }

  Validator onNotBingValid(NotPass notPass) {
    _notBeingValid = notPass;
    return this;
  }

  Validator required([String message]) {
    rule(
      message ?? _messages.require,
      (evaluate) => evaluate!=null && evaluate.isNotEmpty
    );
    return this;
  }

  Validator length(int condition, [String message]) {
    rule(
      (message ?? _messages.length).replaceFirst('%x', '$condition'),
      (evaluate) => evaluate!=null && evaluate.length==condition
    );
    return this;
  }

  Validator minLength(int condition, [String message]) {
    rule(
      (message ?? _messages.minLength).replaceFirst('%x', '$condition'),
      (evaluate) => evaluate!=null && evaluate.length<=condition
    );
    return this;
  }

  Validator maxLength(int condition, [String message]) {
    rule(
      (message ?? _messages.maxLength).replaceFirst('%x', '$condition'),
      (evaluate) => evaluate!=null && evaluate.length>=condition
    );
    return this;
  }

  Validator email([String message]) {
    rule(
      message ?? _messages.email,
      (evaluate) => evaluate!=null && _EMAIL_RE.hasMatch(evaluate)
    );
    return this;
  }

  Validator numericFormat([String message]) {
    rule(
      message ?? _messages.numericFormat,
      (evaluate) => evaluate!=null && double.tryParse(evaluate)!=null
    );
    return this;
  }

  Validator shouldOnlyContain(String condition, [String message]) {
    rule(
      (message ?? _messages.shouldOnlyContain).replaceFirst('%x', '$condition'),
      (evaluate) {
        if (evaluate==null) return false;
        for (var i=0; i<evaluate.length; i++) {
          if (!condition.contains(evaluate[i])) return false;
        }
        return true;
      }
    );
    return this;
  }

  Validator onlyNumbers([String message]) {
    // TODO: Crear constantes
    shouldOnlyContain("123456789", (message ?? _messages.onlyNumbers));
    return this;
  }

  Validator notContain(String condition, [String message]) {
    rule(
      (message ?? _messages.notContain).replaceFirst('%x', '$condition'),
      (evaluate) {
        if (evaluate==null) return false;
        for (var i=0; i<condition.length; i++) {
          if (evaluate.contains(condition[i])) return false;
        }
        return true;
      }
    );
    return this;
  }

  Validator mustContainOne(String condition, [String message]) {
    rule(
      (message ?? _messages.mustContainOne).replaceFirst('%x', '$condition'),
      (evaluate) {
        if (evaluate==null) return false;
        for (var i=0; i<condition.length; i++) {
          if (evaluate.contains(condition[i])) return true;
        }
        return false;
      }
    );
    return this;
  }

  Validator copy() {
    return Validator._(_rules, _notBeingValid);
  }

  void dispose() {
    _notBeingValid = null;
  }

}