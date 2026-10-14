import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  final prefs = await SharedPreferences.getInstance();

  runApp(CalcApp(prefs: prefs));
}

class CalcApp extends StatefulWidget {
  final SharedPreferences prefs;

  const CalcApp({super.key, required this.prefs});

  @override
  State<CalcApp> createState() => _CalcAppState();
}

class _CalcAppState extends State<CalcApp> {
  late final ValueNotifier<bool> _darkMode;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _darkMode = ValueNotifier<bool>(widget.prefs.getBool('darkMode') ?? false);

    _router = createRouter(
      prefs: widget.prefs,
      darkMode: _darkMode,
      toggleTheme: _toggleTheme,
    );
  }

  Future<void> _toggleTheme() async {
    _darkMode.value = !_darkMode.value;

    await widget.prefs.setBool('darkMode', _darkMode.value);
  }

  @override
  void dispose() {
    _darkMode.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _darkMode,
      builder: (context, darkMode, child) {
        return MaterialApp.router(
          title: 'Калькулятор и конвертер',
          debugShowCheckedModeBanner: false,

          // СВЕТЛАЯ ТЕМА
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFFFF0F5),

            colorScheme:
                ColorScheme.fromSeed(
                  seedColor: const Color(0xFFF2A7B8),
                  brightness: Brightness.light,
                ).copyWith(
                  primary: const Color(0xFFE89AAA),
                  onPrimary: Colors.black,
                  surface: const Color(0xFFFFF8FA),
                  onSurface: Colors.black,
                  onSurfaceVariant: const Color(0xFF59464D),
                  outlineVariant: const Color(0xFFE8C5CF),
                ),

            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFFDDE5),
              foregroundColor: Colors.black,
              centerTitle: true,
            ),

            textTheme: ThemeData.light().textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),

            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFFFFF8FA),
              labelStyle: TextStyle(color: Color(0xFF59464D)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE8C5CF)),
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE89AAA), width: 2),
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
            ),

            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF2B8C6),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          // ТЁМНАЯ ТЕМА
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF171115),

            colorScheme:
                ColorScheme.fromSeed(
                  seedColor: const Color(0xFFE89AAA),
                  brightness: Brightness.dark,
                ).copyWith(
                  primary: const Color(0xFFF2B8C6),
                  onPrimary: const Color(0xFF24151B),
                  surface: const Color(0xFF2D2228),
                  onSurface: const Color(0xFFFFF1F5),
                  onSurfaceVariant: const Color(0xFFDCC9D0),
                  outlineVariant: const Color(0xFF624853),
                ),

            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF241B20),
              foregroundColor: Color(0xFFFFF1F5),
              centerTitle: true,
            ),

            textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: const Color(0xFFFFF1F5),
              displayColor: const Color(0xFFFFF1F5),
            ),

            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFF2D2228),
              labelStyle: TextStyle(color: Color(0xFFDCC9D0)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF624853)),
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF2B8C6), width: 2),
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
            ),

            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF8E596C),
                foregroundColor: const Color(0xFFFFF1F5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,

          routerConfig: _router,
        );
      },
    );
  }
}
