import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionService {
  static Future<String> getVersionInfo(GraphQLClient client) async {
    try {
      final QueryResult result = await client.query(
        QueryOptions(
          document: Queries.config,
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        CustomErrorHandler.captureException(result.exception.toString(),
            stackTrace: result.exception!.originalStackTrace);
        return 'Error';
      }

      return result.data!["config"]?[0]?["min_version"];
    } catch (e, stackTrace) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: stackTrace);
      return 'Error';
    }
  }

  static Future<String> getCurrentAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static bool verifyVersionString(
      {required String currentVersion, required String minVersion}) {
    List<int> currentVersionNumbers =
        currentVersion.split(".").map((version) => int.parse(version)).toList();
    List<int> minVersionNumbers =
        minVersion.split(".").map((version) => int.parse(version)).toList();
    for (int i = 0; i < 3; i++) {
      if (currentVersionNumbers[i] < minVersionNumbers[i]) {
        return false;
      }
      if (currentVersionNumbers[i] > minVersionNumbers[i]) {
        return true;
      }
    }
    return true;
  }
}
