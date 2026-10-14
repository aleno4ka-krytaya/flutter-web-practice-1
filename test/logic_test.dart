
import 'package:flutter_test/flutter_test.dart';
import 'package:calc_web/logic/calculator.dart';
import 'package:calc_web/logic/currency.dart';

void main() {
  group('Тесты калькулятора', () {
    test('Сложение двух чисел', () {
      final result = calculate('10', '+', '5');

      expect(result, isA<CalcSuccess>());
      expect((result as CalcSuccess).value, 15);
    });

    test('Вычитание двух чисел', () {
      final result = calculate('10', '-', '5');

      expect(result, isA<CalcSuccess>());
      expect((result as CalcSuccess).value, 5);
    });

    test('Умножение двух чисел', () {
      final result = calculate('10', '*', '5');

      expect(result, isA<CalcSuccess>());
      expect((result as CalcSuccess).value, 50);
    });

    test('Деление двух чисел', () {
      final result = calculate('10', '/', '2');

      expect(result, isA<CalcSuccess>());
      expect((result as CalcSuccess).value, 5);
    });

    test('Деление на ноль возвращает ошибку', () {
      final result = calculate('10', '/', '0');

      expect(result, isA<CalcFailure>());
    });

    test('Некорректное число возвращает ошибку', () {
      final result = calculate('abc', '+', '5');

      expect(result, isA<CalcFailure>());
    });

    test('Неизвестная операция возвращает ошибку', () {
      final result = calculate('10', '%', '5');

      expect(result, isA<CalcFailure>());
    });

    test('Отсутствующий параметр возвращает ошибку', () {
      final result = calculate(null, '+', '5');

      expect(result, isA<CalcFailure>());
    });

    test('Поддерживается десятичная запятая', () {
      final result = calculate('2,5', '+', '1,5');

      expect(result, isA<CalcSuccess>());
      expect((result as CalcSuccess).value, 4);
    });
  });

  group('Тесты конвертера валют', () {
    test('Конвертация USD в RUB', () {
      final result = convertCurrency('100', 'USD', 'RUB');

      expect(result, isA<CurrencySuccess>());
      expect((result as CurrencySuccess).value, 9000);
    });

    test('Некорректная сумма возвращает ошибку', () {
      final result = convertCurrency('abc', 'USD', 'RUB');

      expect(result, isA<CurrencyFailure>());
    });

    test('Неизвестная валюта возвращает ошибку', () {
      final result = convertCurrency('100', 'USD', 'ABC');

      expect(result, isA<CurrencyFailure>());
    });

    test('Отрицательная сумма возвращает ошибку', () {
      final result = convertCurrency('-100', 'USD', 'RUB');

      expect(result, isA<CurrencyFailure>());
    });

    test('Отсутствующая сумма возвращает ошибку', () {
      final result = convertCurrency(null, 'USD', 'RUB');

      expect(result, isA<CurrencyFailure>());
    });
  });

  group('Форматирование результата', () {
    test('Убираются лишние нули', () {
      expect(formatNumber(5.0), '5');
    });

    test('Ноль отображается корректно', () {
      expect(formatNumber(0), '0');
    });
  });
}

