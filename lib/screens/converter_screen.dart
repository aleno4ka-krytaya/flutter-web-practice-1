import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/currency.dart';

class ConverterScreen extends StatefulWidget {
  final SharedPreferences prefs;

  const ConverterScreen({super.key, required this.prefs});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  late String _from;
  late String _to;

  @override
  void initState() {
    super.initState();

    final savedFrom = widget.prefs.getString('currencyFrom');
    final savedTo = widget.prefs.getString('currencyTo');

    _from = currencyRates.containsKey(savedFrom) ? savedFrom! : 'USD';

    _to = currencyRates.containsKey(savedTo) ? savedTo! : 'RUB';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите сумму';
    }

    final amount = double.tryParse(value.trim().replaceAll(',', '.'));

    if (amount == null || !amount.isFinite || amount < 0) {
      return 'Введите корректную сумму';
    }

    return null;
  }

  Future<void> _saveCurrencies() async {
    await widget.prefs.setString('currencyFrom', _from);

    await widget.prefs.setString('currencyTo', _to);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _saveCurrencies();

    if (!mounted) return;

    final uri = Uri(
      path: '/converter/result',
      queryParameters: {
        'amount': _amountController.text.trim().replaceAll(',', '.'),
        'from': _from,
        'to': _to,
      },
    );

    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Конвертер валют'),
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
                        Icons.currency_exchange,
                        size: 56,
                        color: colors.primary,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Конвертер валют',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Выбери валюты и введи сумму',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),

                      const SizedBox(height: 28),

                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: TextStyle(color: colors.onSurface),
                        decoration: InputDecoration(
                          labelText: 'Сумма',
                          prefixIcon: Icon(
                            Icons.payments_outlined,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        validator: _validateAmount,
                      ),

                      const SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        initialValue: _from,
                        isExpanded: true,
                        style: TextStyle(color: colors.onSurface, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Из валюты',
                          prefixIcon: Icon(
                            Icons.arrow_upward,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        items: currencyRates.keys.map((currency) {
                          return DropdownMenuItem<String>(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          if (value == null) return;

                          setState(() {
                            _from = value;
                          });

                          await widget.prefs.setString('currencyFrom', value);
                        },
                      ),

                      const SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        initialValue: _to,
                        isExpanded: true,
                        style: TextStyle(color: colors.onSurface, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'В валюту',
                          prefixIcon: Icon(
                            Icons.arrow_downward,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        items: currencyRates.keys.map((currency) {
                          return DropdownMenuItem<String>(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          if (value == null) return;

                          setState(() {
                            _to = value;
                          });

                          await widget.prefs.setString('currencyTo', value);
                        },
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.currency_exchange),
                          label: const Text(
                            'Конвертировать',
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
