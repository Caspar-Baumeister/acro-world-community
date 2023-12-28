import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class FavoriteClassMutationWidget extends StatefulWidget {
  const FavoriteClassMutationWidget({
    super.key,
    required this.classId,
    required this.initialFavorized,
    required this.color,
  });

  final String classId;
  final bool initialFavorized;
  final Color color;

  @override
  State<FavoriteClassMutationWidget> createState() =>
      _FavoriteClassMutationWidgetState();
}

class _FavoriteClassMutationWidgetState
    extends State<FavoriteClassMutationWidget> {
  late bool isFavorized;

  @override
  void initState() {
    isFavorized = widget.initialFavorized;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      child: Mutation(
        options: MutationOptions(
          document: isFavorized
              ? Mutations.unFavoritizeClass
              : Mutations.favoritizeClass,
          onCompleted: (dynamic resultData) {
            setState(() {
              isFavorized = !isFavorized;
            });
            Fluttertoast.showToast(
                msg: "${isFavorized ? "Added to" : "Removed from"} favorites",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          },
        ),
        builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                    {Object? optimisticResult})
                runMutation,
            QueryResult<dynamic>? result) {
          if (result == null || result.hasException) {
            // ignore: avoid_print
            print(result?.exception.toString());
            return Container();
          }
          if (result.isLoading) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isFavorized ? Icons.favorite : Icons.favorite_border,
                color: widget.color,
              ),
            );
          }

          return IconButton(
            icon: Icon(
              isFavorized ? Icons.favorite : Icons.favorite_border,
              color: widget.color,
            ),
            onPressed: () => isFavorized
                ? runMutation({
                    'class_id': widget.classId,
                    'user_id': Provider.of<UserProvider>(context, listen: false)
                        .activeUser!
                        .id!
                  })
                : runMutation({
                    'class_id': widget.classId,
                  }),
          );
        },
      ),
    );
  }
}
