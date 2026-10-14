import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundScreen extends StatelessWidget {
  final String location;

  const NotFoundScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Страница не найдена')),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),

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
                  children: [
                    Icon(Icons.search_off, size: 90, color: colors.primary),

                    const SizedBox(height: 20),

                    Text(
                      '404',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Такой страницы нет',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Проверь адрес или вернись на главную.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),

                    const SizedBox(height: 12),

                    SelectableText(
                      'Адрес: $location',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => context.go('/'),
                        child: const Text('На главную'),
                      ),
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
