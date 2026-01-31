import 'package:pubspec_parse/pubspec_parse.dart';

import '../../assets/pubspec.asset.dart';

class ApiServiceVersion {
  Future<String> load() async {
    final Pubspec pubspec;
    try {
      final contents = await PubspecAsset.load();
      pubspec = Pubspec.parse(contents);
    } catch (_) {
      throw ApiServiceVersionError.loadFailed;
    }

    if (pubspec.version case var version?) {
      return version.toString();
    } else {
      throw ApiServiceVersionError.notFound;
    }
  }
}

enum ApiServiceVersionError implements Exception { loadFailed, notFound }
