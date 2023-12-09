import 'package:acroworld/components/wrapper/loggin_wrapper.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/screens/system_pages/error_page.dart';
import 'package:acroworld/screens/system_pages/loading_page.dart';
import 'package:acroworld/screens/system_pages/version_to_old_page.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionWrapper extends StatefulWidget {
  const VersionWrapper({Key? key}) : super(key: key);

  @override
  State<VersionWrapper> createState() => _VersionWrapperState();
}

class _VersionWrapperState extends State<VersionWrapper> {
  @override
  Widget build(BuildContext context) {
    print('_VersionWrapperState:build');
    return Query(
      options: QueryOptions(
        document: Queries.config,
        fetchPolicy: FetchPolicy.networkOnly,
      ),
      builder: (QueryResult queryResult,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (queryResult.hasException) {
          return ErrorPage(
            error: queryResult.exception.toString(),
          );
        } else if (queryResult.isLoading) {
          print('_VersionWrapperState:build - queryResult.isLoading');
          return const LoadingPage();
        } else if (queryResult.data != null) {
          print('_VersionWrapperState:build - queryResult.data != null');
          String? minVersion = queryResult.data!["config"]?[0]?["min_version"];
          if (minVersion != null) {
            // ignore: avoid_print
            print("minVersion");
            // ignore: avoid_print
            print(minVersion);
            return FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    return ErrorPage(
                        error:
                            "PackageInfo current version error: ${snapshot.error}");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    try {
                      PackageInfo packageInfo = snapshot.data!;
                      String currentVersion = packageInfo.version;

                      bool isValid = verifyVersionString(
                          currentVersion: currentVersion,
                          minVersion: minVersion);

                      if (isValid) {
                        return const LogginWrapper();
                      } else {
                        return VersionToOldPage(
                            currentVersion: currentVersion,
                            minVersion: minVersion);
                      }
                    } catch (e) {
                      return ErrorPage(error: e.toString());
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const LoadingPage();
                  } else {
                    return ErrorPage(
                        error:
                            "connectionState: ${snapshot.connectionState.toString()} ${snapshot.toString()}");
                  }
                }));
          } else {
            return const ErrorPage(
                error:
                    'queryResult.data!["config"]?[0]?["min_version"] is null');
          }
        } else {
          return ErrorPage(
            error:
                "Unknown error in loading the config. Consider updating your app version: ${queryResult.toString()}",
          );
        }
      },
    );
  }

  bool verifyVersionString(
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
