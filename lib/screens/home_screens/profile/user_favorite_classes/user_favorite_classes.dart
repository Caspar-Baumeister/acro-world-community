import 'package:acroworld/components/class_widgets/class_template_card.dart';
import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/models/favorite_model.dart';
import 'package:acroworld/screens/system_pages/error_page.dart';
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
          return const LoadingWidget();
        } else if (queryResult.data != null &&
            queryResult.data?["me"] != null) {
          try {
            List favorites = queryResult.data!["me"]![0]?["class_favorits"];
            List<FavoriteModel> favoriteModels =
                favorites.map((e) => FavoriteModel.fromJson(e)).toList();
            return favoriteModels.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        "You have no favorite activities",
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: favoriteModels.length,
                    itemBuilder: ((context, index) {
                      ClassModel event = favoriteModels[index].classObject!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: ClassTemplateCard(indexClass: event),
                      );
                    }));
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
