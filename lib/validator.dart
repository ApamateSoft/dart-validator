import 'src/Messages.dart';
import 'src/Functions.dart';

void main(List<String> arguments) {

  final VALID_EMAIL = 'jealmesa@gmail.com';
  final INVALID_EMAIL = 'watagatapitusberry';

  final VALIDATOR_TEMPLATE = Validator()
    .required()
    .email();

  final EMAIL_VALID = VALIDATOR_TEMPLATE.copy();
  final EMAIL_INVALID = VALIDATOR_TEMPLATE.copy();

  EMAIL_INVALID.onNotPass( (message) => print(message) );
  EMAIL_VALID.onNotPass( (message) => print(message) );

  print("'$VALID_EMAIL' es un email valido?: "+EMAIL_VALID.isValid(VALID_EMAIL).toString());
  print("'$INVALID_EMAIL' es un email valido?: "+EMAIL_INVALID.isValid(INVALID_EMAIL).toString());

}

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

  /// Valida que el String a evaluar cumpla todas las reglas.<br>
  /// <b>Nota:</b> Si el String no cumple alguna regla, se invocara al evento {@link #notPass(NotPass)} con el mensaje
  /// del error correspondiente.
  /// @param evaluate String a evaluar.
  /// @return true: si pasa la validación.
  bool isValid(String evaluate) {
    for (final rule in _rules) {
      if (!rule.isValid(evaluate)) {
        if (_notPass!=null) _notPass(rule.getMessage());
        return false;
      }
    }
    return true;
  }

  /// Crea una regla de validación.
  /// <br><br>
  /// <b>Ejemplo:<b/><br>
  /// <code>
  /// <pre>
  /// final validator = Validator();
  /// validator.rule("El texto es diferente de ejemplo", (evaluate) {
  ///     return evaluate.equals("ejemplo");
  /// });
  /// </pre>
  /// </code>
  ///
  /// @param message Mensaje de error.
  /// @param validate Función que retorna true cuando el String a evaluar cumpla las condiciones.
  Validator rule(String message, Validate validate) {
    _rules.add(Rule(message, validate));
    return this;
  }

  /// Evento que se invoca al no cumplirse alguna regla.
  /// @param notPass Función con el mensaje de error.
  Validator onNotPass(NotPass notPass) {
    _notPass = notPass;
    return this;
  }

  /// Valida que el String a evaluar sea diferente de un vacío y null.
  /// @param message Mensaje de error.
  Validator required([String message]) {
    rule(message ?? _messages.require, (evaluate) {
      if (evaluate==null) return false;
      return evaluate.isNotEmpty;
    });
    return this;
  }

  /// Valida que el String a evaluar tenga la longitud exacta de carácteres a la condición.
  /// @param condition longitud de caracteres.
  /// @param message Mensaje de error.
  Validator length(int condition, [String message]) {
    rule((message ?? _messages.length).replaceFirst('%x', '$condition'), (evaluate) => evaluate.length==condition);
    return this;
  }

  /// Valida que el String a evaluar tenga una longitud de caracteres minima a la condición.
  /// @param condition Longitud minima de carácteres.
  /// @param message Mensaje de error.
  Validator minLength(int condition, [String message]) {
    rule((message ?? _messages.minLength).replaceFirst('%x', '$condition'), (evaluate) => evaluate.length>=condition);
    return this;
  }

  /// Valida que el String a evaluar tenga una longitud maxima de carácteres a la condición.
  /// @param condition longitud maxima de carácteres.
  /// @param message Mensaje de error.
  Validator maxLength(int condition, [String message]) {
    rule((message ?? _messages.maxLength).replaceFirst('%x', '$condition'), (evaluate) => evaluate.length<=condition);
    return this;
  }

  /// Valida que el String a evaluar tenga un formato de email
  /// @param message Mensaje de error.
  Validator email([String message]) {
    rule(message ?? _messages.email, (evaluate) => _EMAIL_RE.hasMatch(evaluate) );
    return this;
  }

  /// Valida que el String a evaluar tenga un formato numérico.
  /// @param message Mensaje de error.
  Validator numericFormat([String message]) {
    rule(message ?? _messages.numericFormat, (evaluate) => double.tryParse(evaluate)!=null );
    return this;
  }

  /// Valida que el String a evaluar solo contenga carácteres incluidos en [condition].
  Validator shouldOnlyContain(String condition, [String message]) {
    rule((message ?? _messages.shouldOnlyContain).replaceFirst('%x', '$condition'), (evaluate) {
      for (var i=0; i<evaluate.length; i++) {
        if (!condition.contains(evaluate[i])) return false;
      }
      return true;
    });
    return this;
  }

  /// Valida que el Staring a evaluar solo contenga carácteres numéricos.
  /// @param message Mensaje de error.
  Validator onlyNumbers([String message]) {
    // TODO: Crear constantes
    shouldOnlyContain("123456789", (message ?? _messages.onlyNumbers));
    return this;
  }

  /// Valida que el String a evaluar no contenga algún carácter incluido en el String de la condición.
  /// @param condition String con caracteres no válidos.
  /// @param message Mensaje de error.
  Validator notContain(String condition, [String message]) {
    rule((message ?? _messages.notContain).replaceFirst('%x', '$condition'), (evaluate) {
      for (var i=0; i<condition.length; i++) {
        if (evaluate.contains(condition[i])) return false;
      }
      return true;
    });
    return this;
  }

  /// Valida que el String a evaluar contenga al menos un carácter incluido en el String de la condición.
  /// @param condition String con caracteres deseados.
  /// @param message Mensaje de error.
  Validator mustContainOne(String condition, [String message]) {
    rule((message ?? _messages.mustContainOne).replaceFirst('%x', '$condition'), (evaluate) {
      for (var i=0; i<condition.length; i++) {
        if (evaluate.contains(condition[i])) return true;
      }
      return false;
    });
    return this;
  }

  /// Crea una copia del objeto Validator.<br>
  /// @return copia de Validator.
  Validator copy() {
    return Validator._(_rules, _notPass);
  }

}