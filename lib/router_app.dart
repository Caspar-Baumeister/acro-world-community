// ignore_for_file: file_names

import 'package:acroworld/routing/custom_go_router.dart';
import 'package:acroworld/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouterApp extends ConsumerWidget {
  const RouterApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(routerProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
    );
  }
}
