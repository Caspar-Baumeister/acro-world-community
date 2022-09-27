import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:acroworld/shared/widgets/loading_indicator/loading_indicator.dart';
import 'package:acroworld/widgets/users/user_list.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gql/ast.dart';

class UserListQuery extends StatefulWidget {
  const UserListQuery({Key? key, required this.query, required this.variables})
      : super(key: key);

  final DocumentNode query;
  final Map<String, dynamic> variables;

  @override
  State<UserListQuery> createState() => _UserListQueryState();
}

class _UserListQueryState extends State<UserListQuery> {
  late Map<String, dynamic> variablesState;
  List<User> users = [];
  final ScrollController scrollController = ScrollController();
  int limit = 20;
  int offset = 0;
  bool isLoading = false;

  @override
  void initState() {
    variablesState = widget.variables;
    variablesState['limit'] = limit;
    variablesState['offset'] = offset;

    super.initState();
  }

  List<User> parseResultData(dynamic resultData) {
    return List<User>.from(
      resultData['users'].map(
        (userJson) => User.fromJson(userJson),
      ),
    );
  }

  void addResultData(dynamic resultData) {
    List<User> newUsers = parseResultData(resultData);
    if (newUsers.isNotEmpty) {
      bool isAlreadyIn = false;
      for (var user in users) {
        if (user.id == newUsers[0].id) {
          isAlreadyIn = true;
        }
      }
      if (!isAlreadyIn) {
        users.addAll(newUsers);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: widget.query,
        variables: variablesState,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        scrollController.addListener(() {
          if (scrollController.offset ==
              scrollController.position.maxScrollExtent) {
            if (fetchMore != null) {
              variablesState['offset'] = variablesState['offset'] + limit;
              fetchMore(
                FetchMoreOptions.partial(
                    variables: variablesState,
                    updateQuery: (Map<String, dynamic>? previousResultData,
                        Map<String, dynamic>? fetchMoreResultData) {
                      addResultData(fetchMoreResultData!);
                      return {};
                    }),
              );
            }
          }
        });
        //Initial loading
        if (result.isLoading && result.data == null) {
          return const Loading();
        }
        print(result.isLoading);
        if (result.data != null) {
          addResultData(result.data!);
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                UserList(
                  users: users,
                ),
                result.isLoading ? const LoadingIndicator() : Container()
              ],
            ),
          );
        } else {
          print(result.exception);
          return const Center(child: Text('Something went wrong'));
        }
      },
    );
  }
}
