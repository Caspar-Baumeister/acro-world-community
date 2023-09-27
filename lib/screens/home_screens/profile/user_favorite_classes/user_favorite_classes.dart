import 'package:acroworld/components/class_widgets/class_template_card.dart';
import 'package:acroworld/components/loading_widget.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/models/favorite_model.dart';
import 'package:acroworld/screens/system_pages/error_page.dart';
import 'package:acroworld/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserFavoriteClasses extends StatelessWidget {
  const UserFavoriteClasses({Key? key}) : super(key: key);

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
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "You have no favorite activities",
                            style: H16W7,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Get informed about changes and receive important messages from the organisers",
                            style: H14W4.copyWith(
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
