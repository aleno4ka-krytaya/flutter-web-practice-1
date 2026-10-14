sealed class CalcResult {
  const CalcResult();
}

class CalcSuccess extends CalcResult {
  final double value;

  const CalcSuccess(this.value);
}

class CalcFailure extends CalcResult {
  final String message;

  const CalcFailure(this.message);
}

CalcResult calculate(String? rawA, String? rawOp, String? rawB) {
  if (rawA == null ||
      rawB == null ||
      rawOp == null ||
      rawA.trim().isEmpty ||
      rawB.trim().isEmpty ||
      rawOp.trim().isEmpty) {
    return const CalcFailure('Не хватает обязательных параметров');
  }

  final a = double.tryParse(rawA.replaceAll(',', '.'));
  final b = double.tryParse(rawB.replaceAll(',', '.'));

  if (a == null || b == null || !a.isFinite || !b.isFinite) {
    return const CalcFailure('Введите корректные числа');
  }

  final CalcResult result = switch (rawOp) {
    '+' => CalcSuccess(a + b),
    '-' => CalcSuccess(a - b),
    '*' => CalcSuccess(a * b),
    '/' =>
      b == 0
          ? const CalcFailure('Деление на ноль невозможно')
          : CalcSuccess(a / b),
    _ => const CalcFailure('Неизвестная операция'),
  };

  if (result is CalcSuccess && !result.value.isFinite) {
    return const CalcFailure('Результат выходит за допустимые пределы');
  }

  return result;
}

String formatNumber(double value) {
  if (value.abs() < 0.0000005) {
    return '0';
  }

  return value
      .toStringAsFixed(6)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}
