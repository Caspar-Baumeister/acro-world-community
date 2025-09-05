import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/main_pages/profile/user_favorite_classes/user_favorite_classes.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "My Favorites",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: false,
        elevation: 0,
      ),
      child: const FavoritesBody(),
    );
  }
}

class FavoritesBody extends StatelessWidget {
  const FavoritesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh favorites data
        await Future.delayed(const Duration(seconds: 1));
      },
      child: const UserFavoriteClasses(),
    );
  }
}
