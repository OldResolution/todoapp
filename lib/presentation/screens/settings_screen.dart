import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/utils.dart';
import '../../logic/providers/auth_provider.dart';
import 'timer_settings_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoading = false;

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
              title: const Text('Settings'),
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
                    child: Column(
                      children: [
                        ListTile(
                              leading: Icon(
                                Icons.timer,
                                color: theme.colorScheme.primary,
                              ),
                              title: const Text('Timer Settings'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap:
                                  _isLoading
                                      ? null
                                      : () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  const TimerSettingsScreen(),
                                        ),
                                      ),
                            )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideX(begin: 0.2, end: 0.0),
                        const Divider(height: 1),
                        ListTile(
                              leading: Icon(
                                Icons.palette,
                                color: theme.colorScheme.primary,
                              ),
                              title: const Text('Dark Mode'),
                              trailing: Switch(
                                value: theme.brightness == Brightness.dark,
                                onChanged: (value) {
                                  // TODO: Implement theme toggle
                                  // For now, show a placeholder message
                                  AppUtils.showSnackBar(
                                    context,
                                    'Theme toggle coming soon!',
                                  );
                                },
                              ),
                              onTap: () {
                                // Trigger switch toggle
                                AppUtils.showSnackBar(
                                  context,
                                  'Theme toggle coming soon!',
                                );
                              },
                            )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 100.ms)
                            .slideX(begin: 0.2, end: 0.0),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: theme.colorScheme.error,
                      ),
                      title: Text(
                        'Sign Out',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                      onTap:
                          _isLoading
                              ? null
                              : () async {
                                final shouldLogout = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text('Sign Out'),
                                        content: const Text(
                                          'Are you sure you want to sign out?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  context,
                                                  true,
                                                ),
                                            child: const Text('Sign Out'),
                                          ),
                                        ],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                );

                                if (shouldLogout ?? false) {
                                  setState(() => _isLoading = true);
                                  try {
                                    await ref
                                        .read(authNotifierProvider.notifier)
                                        .signOut();
                                    if (mounted) {
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pushReplacementNamed('/auth');
                                      AppUtils.showSnackBar(
                                        context,
                                        'Signed out successfully',
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      AppUtils.showSnackBar(
                                        context,
                                        'Error: $e',
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() => _isLoading = false);
                                    }
                                  }
                                }
                              },
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
