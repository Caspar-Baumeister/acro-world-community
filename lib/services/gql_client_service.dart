import 'package:acroworld/environment.dart';
import 'package:acroworld/exceptions/error_handler.dart'; // Import your error handler
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
      print("Reinitializing client as teacher");
      authLink = CustomAuthLink(
        getToken: () async {
          // Returns the raw token.
          String? token = await TokenSingletonService().getToken();
          return token;
        },
      );
    } else {
      authLink = AuthLink(
        getToken: () async {
          String? token = await TokenSingletonService().getToken();
          // Return null if no token is available so that no malformed header is sent.
          if (token == null || token.isEmpty) return null;
          return 'Bearer $token';
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

    // Exempt certain operations from adding headers (e.g., refreshing tokens)
    if (request.operation.operationName == "LoginWithRefreshToken") {
      yield* forward!(request);
      return;
    }

    final token = await getToken?.call();
    if (token != null && token.isNotEmpty) {
      try {
        final decodedToken = Jwt.parseJwt(token);
        final claims = decodedToken["https://hasura.io/jwt/claims"];
        String roleWithHighestPrivileges = 'User'; // default role
        if (claims is Map &&
            claims["x-hasura-allowed-roles"] is List<dynamic>) {
          final allowedRoles =
              claims["x-hasura-allowed-roles"] as List<dynamic>;
          if (allowedRoles.contains('AdminUser')) {
            roleWithHighestPrivileges = 'AdminUser';
          } else if (allowedRoles.contains('TeacherUser')) {
            roleWithHighestPrivileges = 'TeacherUser';
          }
        } else {
          CustomErrorHandler.captureException(
            "CustomAuthLink: Missing or invalid JWT claims in token.",
          );
        }
        headers['authorization'] = 'Bearer $token';
        headers['x-hasura-role'] = roleWithHighestPrivileges;
      } catch (e, stackTrace) {
        await CustomErrorHandler.captureException(e, stackTrace: stackTrace);
      }
    } else {
      print("CustomAuthLink: No token provided.");
    }

    final updatedRequest = request.updateContextEntry<HttpLinkHeaders>(
      (HttpLinkHeaders? previous) => HttpLinkHeaders(
        headers: {
          ...?previous?.headers,
          ...headers,
        },
      ),
    );

    yield* forward!(updatedRequest);
  }
}
