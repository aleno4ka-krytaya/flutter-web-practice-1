const Map<String, double> currencyRates = {
  'RUB': 1.0,
  'USD': 90.0,
  'EUR': 100.0,
  'GBP': 115.0,
  'CNY': 12.5,
};

sealed class CurrencyResult {
  const CurrencyResult();
}

class CurrencySuccess extends CurrencyResult {
  final double value;

  const CurrencySuccess(this.value);
}

class CurrencyFailure extends CurrencyResult {
  final String message;

  const CurrencyFailure(this.message);
}

CurrencyResult convertCurrency(String? rawAmount, String? from, String? to) {
  if (rawAmount == null ||
      from == null ||
      to == null ||
      rawAmount.trim().isEmpty ||
      from.isEmpty ||
      to.isEmpty) {
    return const CurrencyFailure('Отсутствует обязательный параметр');
  }

  final amount = double.tryParse(rawAmount.replaceAll(',', '.'));

  if (amount == null || !amount.isFinite || amount < 0) {
    return const CurrencyFailure('Введите корректную сумму');
  }

  if (!currencyRates.containsKey(from) || !currencyRates.containsKey(to)) {
    return const CurrencyFailure('Неизвестная валюта');
  }

  final result = amount * currencyRates[from]! / currencyRates[to]!;

  if (!result.isFinite) {
    return const CurrencyFailure('Не удалось выполнить конвертацию');
  }

  return CurrencySuccess(result);
}
