import 'package:acroworld/data/graphql/queries.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/data/models/favorite_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/cards/modern_class_event_card.dart';
import 'package:acroworld/presentation/components/loading/modern_loading_widget.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/system_pages/error_page.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserFavoriteClasses extends StatelessWidget {
  const UserFavoriteClasses({super.key});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: Queries.userFavorites,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
      builder: (QueryResult queryResult,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (queryResult.hasException) {
          return ErrorWidget(queryResult.exception.toString());
        } else if (queryResult.isLoading) {
          return const ModernLoadingWidget();
        } else if (queryResult.data != null &&
            queryResult.data?["me"] != null) {
          try {
            List favorites = queryResult.data!["me"]![0]?["class_favorits"];
            List<FavoriteModel> favoriteModels =
                favorites.map((e) => FavoriteModel.fromJson(e)).toList();
            return favoriteModels.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.spacingLarge),
                      child: Text(
                        "You have no favorite activities",
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: favoriteModels.map((favorite) {
                        try {
                          ClassModel? event = favorite.classObject;
                          if (event == null) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ModernClassEventCard(
                              classModel: event,
                              width: 160,
                            ),
                          );
                        } catch (e, s) {
                          CustomErrorHandler.captureException(e, stackTrace: s);
                          return const SizedBox.shrink();
                        }
                      }).toList(),
                    ),
                  );
          } catch (e) {
            return const ErrorPage(
                error:
                    "An unexpected error occured, when transforming the class favorits to objects");
          }
        } else {
          return const ErrorPage(
              error:
                  "An unexpected error occured, when fetching class favorits");
        }
      },
    );
  }
}
