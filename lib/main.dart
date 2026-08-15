import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/app_providers.dart';
import 'screens/active_timer_screen.dart';
import 'screens/landing_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: KinetApp(),
    ),
  );
}

class KinetApp extends StatelessWidget {
  const KinetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kinet • by athletes, for athletes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShell(),
    );
  }
}

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell>
    with SingleTickerProviderStateMixin {
  late AnimationController _phaseController;

  @override
  void initState() {
    super.initState();
    // Continuous subtle animated phase shift for mesh background gradient
    _phaseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _phaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _phaseController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: AppTheme.backgroundGradient(_phaseController.value),
            ),
            child: child,
          );
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.05),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: state.isTimerActive
                  ? const ActiveTimerScreen(key: ValueKey('ActiveTimer'))
                  : const LandingScreen(key: ValueKey('LandingScreen')),
            ),
          ),
        ),
      ),
    );
  }
}
