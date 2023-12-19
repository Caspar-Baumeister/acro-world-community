import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlClientService {
  final GraphQLClient _client;

  GraphQlClientService(this._client);

  // query
  Future<QueryResult> query(QueryOptions options) async {
    return await _client.query(options);
  }

  // mutate
  Future<QueryResult> mutate(MutationOptions options) async {
    return await _client.mutate(options);
  }
}
