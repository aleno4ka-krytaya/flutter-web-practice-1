import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aController = TextEditingController();
  final _bController = TextEditingController();

  String _operation = '+';

  static const List<String> _operations = ['+', '-', '*', '/'];

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    super.dispose();
  }

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите число';
    }

    final number = double.tryParse(value.trim().replaceAll(',', '.'));

    if (number == null || !number.isFinite) {
      return 'Введите корректное число';
    }

    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final a = _aController.text.trim().replaceAll(',', '.');

    final b = _bController.text.trim().replaceAll(',', '.');

    final uri = Uri(
      path: '/calculator/result',
      queryParameters: {'a': a, 'op': _operation, 'b': b},
    );

    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор'),
        leading: IconButton(
          tooltip: 'На главную',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),

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
                padding: const EdgeInsets.all(24),

                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [
                      Icon(
                        Icons.calculate_outlined,
                        size: 56,
                        color: colors.primary,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Калькулятор',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Введи числа и выбери операцию',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),

                      const SizedBox(height: 28),

                      TextFormField(
                        controller: _aController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        style: TextStyle(color: colors.onSurface),
                        decoration: InputDecoration(
                          labelText: 'Первое число',
                          prefixIcon: Icon(
                            Icons.looks_one_outlined,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        validator: _validateNumber,
                      ),

                      const SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        initialValue: _operation,
                        isExpanded: true,
                        style: TextStyle(color: colors.onSurface, fontSize: 18),
                        decoration: InputDecoration(
                          labelText: 'Операция',
                          prefixIcon: Icon(
                            Icons.functions,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        items: _operations.map((operation) {
                          return DropdownMenuItem<String>(
                            value: operation,
                            child: Text(operation),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _operation = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _bController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        style: TextStyle(color: colors.onSurface),
                        decoration: InputDecoration(
                          labelText: 'Второе число',
                          prefixIcon: Icon(
                            Icons.looks_two_outlined,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        validator: _validateNumber,
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.calculate),
                          label: const Text(
                            'Вычислить',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
