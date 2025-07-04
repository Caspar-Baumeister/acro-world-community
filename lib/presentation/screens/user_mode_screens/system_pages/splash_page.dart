import 'package:acroworld/presentation/components/loading_widget.dart';
import 'package:acroworld/provider/auth/auth_notifier.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final appLinks = AppLinks();
    final Uri? initialLink = await appLinks.getInitialLink();
    print("🔗 Initial deep link: $initialLink");

    final authState = await ref.read(authProvider.future);
    final isAuthenticated = authState.status == AuthStatus.authenticated;

    final intended = initialLink?.toString() ?? '/';

    if (!isAuthenticated) {
      final from = Uri.encodeComponent(intended);
      if (!mounted) return;
      context.go('/auth?from=$from');
    } else {
      if (!mounted) return;
      context.go(intended);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: LoadingWidget()),
    );
  }
}
