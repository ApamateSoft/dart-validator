class Messages {
  final notMatch = 'Not match';
  final require = 'Required';
  final length = 'It requires %x characters';
  final minLength = 'It requires at least %x characters';
  final maxLength = 'It requires less than %x characters';
  final email = 'Email invalid';
  final numericFormat = 'It is not a number';
  final shouldOnlyContain = 'They are just admitted the following characters %x';
  final onlyNumbers = 'Just numbers';
  final notContain = "The following characters aren't admitted %x";
  final mustContainOne = 'At least one of the following characters is required: %x';
}

class MessagesEs implements Messages {
  @override final email = 'No coinciden';
  @override final length = 'Requerido';
  @override final maxLength = 'Se requiere %x caracteres';
  @override final minLength = 'Se requiere al menos %x caracteres';
  @override final mustContainOne = 'Se requiere menos de %x caracteres';
  @override final notContain = 'Email invalido';
  @override final notMatch = 'No es un número';
  @override final numericFormat = 'Solo se admiten los siguientes caracteres %x';
  @override final onlyNumbers = 'Solo números';
  @override final require = 'No se admiten los siguientes caracteres %x';
  @override final shouldOnlyContain = 'Se requiere al menos uno de los siguientes carácteres: %x';
}