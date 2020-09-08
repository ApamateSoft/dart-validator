import 'src/messages.dart';
import 'src/functions.dart';
import 'src/rule.dart';

class Validator {

  static final _EMAIL_RE = RegExp(r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$");
  static var _messages = Messages();

  List<Rule> _rules = [];
  NotPass _notPass;

  Validator();

  Validator._(final this._rules, final this._notPass);

  static void setMessages(Messages messages) {
    _messages = messages;
  }

  bool isValid(String evaluate) {
    for (final rule in _rules) {
      if (!rule.isValid(evaluate)) {
        if (_notPass!=null) _notPass(rule.getMessage());
        return false;
      }
    }
    return true;
  }

  Validator rule(String message, Validate validate) {
    _rules.add(Rule(message, validate));
    return this;
  }

  Validator onNotPass(NotPass notPass) {
    _notPass = notPass;
    return this;
  }

  Validator required([String message]) {
    rule(message ?? _messages.require, (evaluate) {
      if (evaluate==null) return false;
      return evaluate.isNotEmpty;
    });
    return this;
  }

  Validator length(int condition, [String message]) {
    rule((message ?? _messages.length).replaceFirst('%x', '$condition'), (evaluate) => evaluate.length==condition);
    return this;
  }

  Validator minLength(int condition, [String message]) {
    rule((message ?? _messages.minLength).replaceFirst('%x', '$condition'), (evaluate) => evaluate.length<=condition);
    return this;
  }

  Validator maxLength(int condition, [String message]) {
    rule((message ?? _messages.maxLength).replaceFirst('%x', '$condition'), (evaluate) => evaluate.length>=condition);
    return this;
  }

  Validator email([String message]) {
    rule(message ?? _messages.email, (evaluate) => _EMAIL_RE.hasMatch(evaluate) );
    return this;
  }

  Validator numericFormat([String message]) {
    rule(message ?? _messages.numericFormat, (evaluate) => double.tryParse(evaluate)!=null );
    return this;
  }

  Validator shouldOnlyContain(String condition, [String message]) {
    rule((message ?? _messages.shouldOnlyContain).replaceFirst('%x', '$condition'), (evaluate) {
      for (var i=0; i<evaluate.length; i++) {
        if (!condition.contains(evaluate[i])) return false;
      }
      return true;
    });
    return this;
  }

  Validator onlyNumbers([String message]) {
    // TODO: Crear constantes
    shouldOnlyContain("123456789", (message ?? _messages.onlyNumbers));
    return this;
  }

  Validator notContain(String condition, [String message]) {
    rule((message ?? _messages.notContain).replaceFirst('%x', '$condition'), (evaluate) {
      for (var i=0; i<condition.length; i++) {
        if (evaluate.contains(condition[i])) return false;
      }
      return true;
    });
    return this;
  }

  Validator mustContainOne(String condition, [String message]) {
    rule((message ?? _messages.mustContainOne).replaceFirst('%x', '$condition'), (evaluate) {
      for (var i=0; i<condition.length; i++) {
        if (evaluate.contains(condition[i])) return true;
      }
      return false;
    });
    return this;
  }

  Validator copy() {
    return Validator._(_rules, _notPass);
  }

}