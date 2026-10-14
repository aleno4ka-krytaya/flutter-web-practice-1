import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/converter_screen.dart';
import 'screens/result_screen.dart';
import 'screens/not_found_screen.dart';

GoRouter createRouter({
  required SharedPreferences prefs,
  required ValueNotifier<bool> darkMode,
  required VoidCallback toggleTheme,
}) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            HomeScreen(darkMode: darkMode, toggleTheme: toggleTheme),
      ),
      GoRoute(
        path: '/calculator',
        builder: (context, state) => const CalculatorScreen(),
        routes: [
          GoRoute(
            path: 'result',
            builder: (context, state) => ResultScreen(
              type: 'calculator',
              parameters: state.uri.queryParameters,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/converter',
        builder: (context, state) => ConverterScreen(prefs: prefs),
        routes: [
          GoRoute(
            path: 'result',
            builder: (context, state) => ResultScreen(
              type: 'converter',
              parameters: state.uri.queryParameters,
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        NotFoundScreen(location: state.uri.toString()),
  );
}
