import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mad_lab_mini/core/theme.dart';
import 'package:mad_lab_mini/logic/providers/auth_provider.dart';
import 'package:mad_lab_mini/presentation/screens/auth_screen.dart';
import 'package:mad_lab_mini/presentation/screens/home_screen.dart';
import 'package:mad_lab_mini/presentation/screens/task_screen.dart';
import 'package:mad_lab_mini/presentation/screens/pomodoro_screen.dart';
import 'package:mad_lab_mini/presentation/screens/settings_screen.dart';
import 'package:mad_lab_mini/presentation/screens/timer_settings_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Task Pomodoro',
      theme: AppTheme.lightTheme,
      home: authState.when(
        data: (user) => user != null ? const HomeScreen() : const AuthScreen(),
        loading:
            () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
        error:
            (error, _) => Scaffold(body: Center(child: Text('Error: $error'))),
      ),
      routes: {
        '/task': (context) => const TaskScreen(),
        '/pomodoro': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return PomodoroScreen(taskId: args['taskId']!);
        },
        '/settings': (context) => const SettingsScreen(),
        '/timer_settings': (context) => const TimerSettingsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
