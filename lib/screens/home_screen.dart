import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final ValueNotifier<bool> darkMode;
  final VoidCallback toggleTheme;

  const HomeScreen({
    super.key,
    required this.darkMode,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Калькулятор и конвертер',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: darkMode,
            builder: (context, isDarkMode, child) {
              return IconButton(
                tooltip: isDarkMode
                    ? 'Включить светлую тему'
                    : 'Включить тёмную тему',
                onPressed: toggleTheme,
                icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF382630)
                        : const Color(0xFFFFDDE5),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Icon(
                    Icons.calculate_outlined,
                    size: 64,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  'Добро пожаловать!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Выбери инструмент для работы',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 36),

                _MenuCard(
                  icon: Icons.calculate_outlined,
                  title: 'Калькулятор',
                  description: 'Сложение, вычитание, умножение и деление',
                  onTap: () => context.go('/calculator'),
                ),

                const SizedBox(height: 16),

                _MenuCard(
                  icon: Icons.currency_exchange,
                  title: 'Конвертер валют',
                  description: 'Перевод суммы из одной валюты в другую',
                  onTap: () => context.go('/converter'),
                ),

                const SizedBox(height: 32),

                Text(
                  'Flutter Web • Практическая работа №1',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? const Color(0xFF2D2228) : const Color(0xFFFFDDE5),
      borderRadius: BorderRadius.circular(22),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),

        child: Padding(
          padding: const EdgeInsets.all(22),

          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF49303B)
                      : const Color(0xFFFFF0F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 30, color: colors.onSurface),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.arrow_forward_ios, size: 18, color: colors.onSurface),
            ],
          ),
        ),
      ),
    );
  }
}
