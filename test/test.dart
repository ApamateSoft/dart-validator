import 'package:test/test.dart';
import 'package:validator/validator.dart';

void main() {

  group('require().', () {
    final validator = Validator().required();
    test('return false for null evaluate', () => expect(validator.isValid(null), false) );
    test('return false for empty evaluate', () => expect(validator.isValid(''), false) );
    test('return true for an evaluation other than null or empty', () => expect(validator.isValid('example'), true) );
  });

  group('length()', () {
    final validator = Validator().length(5);
    test('return false for String less than 5', () => expect(validator.isValid('1234'), false) );
    test('return true for String equal than 5', () => expect(validator.isValid('12345'), true) );
    test('return false for String greater than 5', () => expect(validator.isValid('123456'), false) );
  });

  group('minLength()', () {
    final validator = Validator().minLength(5);
    test('return true for String less than 5', () => expect(validator.isValid('1234'), true) );
    test('return true for String equal than 5', () => expect(validator.isValid('12345'), true) );
    test('return false for String greater than 5', () => expect(validator.isValid('123456'), false) );
  });

  group('maxLength()', () {
    final validator = Validator().maxLength(5);
    test('return false for String less than 5', () => expect(validator.isValid('1234'), false) );
    test('return true for String equal than 5', () => expect(validator.isValid('12345'), true) );
    test('return true for String greater than 5', () => expect(validator.isValid('123456'), true) );
  });

  group('email()', () {
    final validator = Validator().email();
    test('return false for strings other than email', () => expect(validator.isValid('example'), false) );
    test('return true for string that are email', () => expect(validator.isValid('example@mail.com'), true) );
  });

  group('numericFormat()', () {
    final validator = Validator().numericFormat();
    test('return false for string other than number', () => expect(validator.isValid('example123'), false) );
    test('return true for string that are number', () => expect(validator.isValid('-0.5'), true) );
  });

  group('numericFormat()', () {
    final validator = Validator().shouldOnlyContain('abc');
    test('return false for string that are not composed only of abc', () => expect(validator.isValid('example123'), false) );
    test('return true for string that are only composed of abc', () => expect(validator.isValid('aaabbcabcabc'), true) );
  });

  group('onlyNumbers()', () {
    final validator = Validator().onlyNumbers();
    test('return false for string that are not composed only of numbers', () => expect(validator.isValid('-0.5'), false) );
    test('return true for string that are only composed of numbers', () => expect(validator.isValid('741852963'), true) );
  });

  group('notContain()', () {
    final validator = Validator().notContain('abc');
    test('return false for string containing abc', () => expect(validator.isValid('example'), false) );
    test('return true for string not containing abc', () => expect(validator.isValid('ex_mple'), true) );
  });

  group('mustContainOne()', () {
    final validator = Validator().mustContainOne('abc');
    test('return false for string not containing abc', () => expect(validator.isValid('ex_mple'), false) );
    test('return true for string containing abc', () => expect(validator.isValid('example'), true) );
  });

}