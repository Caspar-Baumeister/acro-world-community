import 'package:acroworld/environment.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decode/jwt_decode.dart'; // Add this package to decode JWT

// graphql_client_singleton.dart

class GraphQLClientSingleton {
  static final GraphQLClientSingleton _instance =
      GraphQLClientSingleton._internal();
  late GraphQLClient _client;

  factory GraphQLClientSingleton() {
    return _instance;
  }

  GraphQLClientSingleton._internal() {
    _initClient();
  }

  void _initClient() {
    final AuthLink authLink = AuthLink(
      getToken: () async {
        String? token = await TokenSingletonService().getToken();
        return token;
      },
    );

    final HttpLink httpLink = HttpLink(
      'https://${AppEnvironment.backendHost}/hasura/v1/graphql',
    );

    final Link link = authLink.concat(httpLink);

    _client = GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    );
  }

  void updateClient() {
    _initClient();
  }

  Future<QueryResult> query(QueryOptions options) async {
    return await _client.query(options);
  }

  Future<QueryResult> mutate(MutationOptions options) async {
    return await _client.mutate(options);
  }

  GraphQLClient get client => _client;
}

class AuthLink extends Link {
  final Future<String?> Function()? getToken;

  AuthLink({this.getToken});

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final headers = Map<String, String>.from(
      request.context.entry<HttpLinkHeaders>()?.headers ?? {},
    );

    print("current headers: $headers");

    // Exempt certain operations from adding headers
    if (request.operation.operationName == "LoginWithRefreshToken") {
      yield* forward!(request);
      return;
    }

    final token = await getToken?.call();
    if (token != null) {
      final decodedToken = Jwt.parseJwt(token);
      final allowedRoles = decodedToken["https://hasura.io/jwt/claims"]
          ["x-hasura-allowed-roles"] as List<dynamic>;

      print("allowed roles: $allowedRoles");

      final roleWithHighestPrivileges = allowedRoles.contains('AdminUser')
          ? 'AdminUser'
          : allowedRoles.contains('TeacherUser')
              ? 'TeacherUser'
              : 'User';

      headers['authorization'] = 'Bearer $token';
      headers['x-hasura-role'] = roleWithHighestPrivileges;
    }

    final updatedRequest = request.updateContextEntry<HttpLinkHeaders>(
      (HttpLinkHeaders? previous) => HttpLinkHeaders(
        headers: {
          ...previous?.headers ?? {},
          ...headers,
        },
      ),
    );

    yield* forward!(updatedRequest);
  }
}
