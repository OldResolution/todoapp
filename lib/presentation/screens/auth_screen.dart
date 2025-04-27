import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../core/utils.dart';
import '../../logic/providers/auth_provider.dart';
import '../widgets/common_widgets.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!mounted || _isLoading) return;
    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await ref
            .read(authNotifierProvider.notifier)
            .signIn(_emailController.text, _passwordController.text);
      } else {
        await ref
            .read(authNotifierProvider.notifier)
            .register(_emailController.text, _passwordController.text);
      }
      if (mounted) {
        AppUtils.showSnackBar(context, _isLogin ? 'Signed in' : 'Registered');
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showSnackBar(context, e.toString());
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Text(
                      _isLogin ? 'Welcome Back' : 'Join Us',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, end: 0.0),
                const SizedBox(height: 8),
                Text(
                      _isLogin
                          ? 'Sign in to boost your productivity'
                          : 'Start your productivity journey',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 100.ms)
                    .slideY(begin: -0.1, end: 0.0),
                const SizedBox(height: 48),
                CommonWidgets.buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.email,
                        color: theme.colorScheme.primary,
                      ),
                      enabled: !_isLoading,
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideX(begin: -0.2, end: 0.0),
                const SizedBox(height: 16),
                CommonWidgets.buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: theme.colorScheme.primary,
                      ),
                      enabled: !_isLoading,
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideX(begin: 0.2, end: 0.0),
                const SizedBox(height: 24),
                CommonWidgets.buildButton(
                      onPressed: _isLoading ? null : _submit,
                      label: _isLogin ? 'Sign In' : 'Register',
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms)
                    .scale(begin: Offset(0.8, 0.8)),
                const SizedBox(height: 16),
                TextButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin ? 'Create an Account' : 'Already have an account?',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
