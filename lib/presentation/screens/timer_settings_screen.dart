import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/utils.dart';
import '../widgets/common_widgets.dart';

class TimerSettingsScreen extends StatefulWidget {
  const TimerSettingsScreen({super.key});

  @override
  State<TimerSettingsScreen> createState() => _TimerSettingsScreenState();
}

class _TimerSettingsScreenState extends State<TimerSettingsScreen> {
  final _workDurationController = TextEditingController(text: '25');
  final _breakDurationController = TextEditingController(text: '5');
  final _longBreakDurationController = TextEditingController(text: '15');
  bool _isLoading = false;

  @override
  void dispose() {
    _workDurationController.dispose();
    _breakDurationController.dispose();
    _longBreakDurationController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!mounted || _isLoading) return;
    setState(() => _isLoading = true);
    try {
      final workMinutes = int.tryParse(_workDurationController.text) ?? 25;
      final breakMinutes = int.tryParse(_breakDurationController.text) ?? 5;
      final longBreakMinutes =
          int.tryParse(_longBreakDurationController.text) ?? 15;

      if (workMinutes < 1 || breakMinutes < 1 || longBreakMinutes < 1) {
        AppUtils.showSnackBar(context, 'Please enter valid durations');
        return;
      }

      // TODO: Save settings (e.g., to Firestore or SharedPreferences)
      // For now, show a success message
      if (mounted) {
        AppUtils.showSnackBar(context, 'Timer settings saved');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showSnackBar(context, 'Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Timer Settings'),
              centerTitle: true,
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              pinned: true,
              elevation: 0,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                                'Pomodoro Durations',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: -0.2, end: 0.0),
                          const SizedBox(height: 16),
                          CommonWidgets.buildTextField(
                                controller: _workDurationController,
                                label: 'Work Duration (minutes)',
                                keyboardType: TextInputType.number,
                                prefixIcon: Icon(
                                  Icons.work,
                                  color: theme.colorScheme.primary,
                                ),
                                enabled: !_isLoading,
                              )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 100.ms)
                              .slideX(begin: -0.2, end: 0.0),
                          const SizedBox(height: 16),
                          CommonWidgets.buildTextField(
                                controller: _breakDurationController,
                                label: 'Short Break (minutes)',
                                keyboardType: TextInputType.number,
                                prefixIcon: Icon(
                                  Icons.coffee,
                                  color: theme.colorScheme.primary,
                                ),
                                enabled: !_isLoading,
                              )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 200.ms)
                              .slideX(begin: 0.2, end: 0.0),
                          const SizedBox(height: 16),
                          CommonWidgets.buildTextField(
                                controller: _longBreakDurationController,
                                label: 'Long Break (minutes)',
                                keyboardType: TextInputType.number,
                                prefixIcon: Icon(
                                  Icons.free_breakfast,
                                  color: theme.colorScheme.primary,
                                ),
                                enabled: !_isLoading,
                              )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 300.ms)
                              .slideX(begin: -0.2, end: 0.0),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 24),
                  CommonWidgets.buildButton(
                        onPressed: _isLoading ? null : _saveSettings,
                        label: 'Save Settings',
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 400.ms)
                      .scale(begin: Offset(0.8, 0.8)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
