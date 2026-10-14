import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../logic/calculator.dart';
import '../logic/currency.dart';

class ResultScreen extends StatelessWidget {
  final String type;
  final Map<String, String> parameters;

  const ResultScreen({super.key, required this.type, required this.parameters});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isCalculator = type == 'calculator';

    final backPath = isCalculator ? '/calculator' : '/converter';

    String title;
    String expression;
    String? resultText;
    String? error;

    if (isCalculator) {
      title = 'Результат вычисления';

      final a = parameters['a'];
      final b = parameters['b'];
      final op = parameters['op'];

      expression = '${a ?? "?"} ${op ?? "?"} ${b ?? "?"}';

      final result = calculate(a, op, b);

      if (result is CalcSuccess) {
        resultText = formatNumber(result.value);
      } else if (result is CalcFailure) {
        error = result.message;
      }
    } else {
      title = 'Результат конвертации';

      final amount = parameters['amount'];
      final from = parameters['from'];
      final to = parameters['to'];

      expression = '${amount ?? "?"} ${from ?? "?"} → ${to ?? "?"}';

      final result = convertCurrency(amount, from, to);

      if (result is CurrencySuccess) {
        resultText = '${formatNumber(result.value)} ${to ?? ""}';
      } else if (result is CurrencyFailure) {
        error = result.message;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),

            child: Card(
              color: colors.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: colors.outlineVariant),
              ),

              child: Padding(
                padding: const EdgeInsets.all(28),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    Icon(
                      error == null
                          ? Icons.check_circle_outline
                          : Icons.error_outline,
                      size: 72,
                      color: error == null ? colors.primary : colors.error,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      expression,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface,
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (error == null)
                      Text(
                        'Результат',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: colors.onSurfaceVariant,
                        ),
                      ),

                    const SizedBox(height: 8),

                    if (error == null)
                      Text(
                        resultText ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      )
                    else
                      Text(
                        error,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: colors.onSurface),
                      ),

                    const SizedBox(height: 30),

                    FilledButton.icon(
                      onPressed: () => context.go(backPath),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Вернуться к форме'),
                    ),

                    const SizedBox(height: 8),

                    TextButton(
                      onPressed: () => context.go('/'),
                      child: const Text('На главную'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
