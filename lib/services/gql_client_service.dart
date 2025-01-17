import 'package:acroworld/environment.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart'
    as http; // Add this package for custom HTTP client
import 'package:jwt_decode/jwt_decode.dart'; // Add this package to decode JWT

class GraphQLClientSingleton {
  static final GraphQLClientSingleton _instance =
      GraphQLClientSingleton._internal();
  late ValueNotifier<GraphQLClient> _clientNotifier;

  factory GraphQLClientSingleton() {
    return _instance;
  }

  GraphQLClientSingleton._internal() {
    _clientNotifier = ValueNotifier(_initClient());
  }

  GraphQLClient _initClient({bool asTeacher = false}) {
    Link authLink;
    if (asTeacher) {
      print("reinit as teacher");
      authLink = CustomAuthLink(
        getToken: () async {
          String? token = await TokenSingletonService().getToken();
          return token;
        },
      );
    } else {
      authLink = AuthLink(
        getToken: () async {
          String? token = await TokenSingletonService().getToken();
          return token != null ? 'Bearer $token' : '';
        },
      );
    }

    // Custom HTTP client with timeout
    final httpLink = HttpLink(
      'https://${AppEnvironment.backendHost}/hasura/v1/graphql',
      httpClient: TimeoutClient(
        timeout: const Duration(seconds: 60), // Set timeout here
      ),
    );

    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      queryRequestTimeout: Duration(seconds: 60), // Set timeout here
      link: link,
      cache: GraphQLCache(store: HiveStore()),
      defaultPolicies: DefaultPolicies(
        query: Policies(
          fetch: FetchPolicy.networkOnly,
          error: ErrorPolicy.all,
        ),
      ),
    );
  }

  void updateClient(bool asTeacher) {
    final newClient = _initClient(asTeacher: asTeacher);
    _clientNotifier.value =
        newClient; // Update the ValueNotifier with the new client
  }

  Future<QueryResult> query(QueryOptions options) async {
    return await _clientNotifier.value.query(options);
  }

  Future<QueryResult> mutate(MutationOptions options) async {
    return await _clientNotifier.value.mutate(options);
  }

  GraphQLClient get client => _clientNotifier.value;
  ValueNotifier<GraphQLClient> get clientNotifier => _clientNotifier;
}

class TimeoutClient extends http.BaseClient {
  final Duration timeout;
  final http.Client _inner;

  TimeoutClient({
    required this.timeout,
    http.Client? client,
  }) : _inner = client ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request).timeout(timeout);
  }
}

class CustomAuthLink extends Link {
  final Future<String?> Function()? getToken;

  CustomAuthLink({this.getToken});

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final headers = Map<String, String>.from(
      request.context.entry<HttpLinkHeaders>()?.headers ?? {},
    );

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
