import 'dart:io';

import 'package:hooks/hooks.dart';
import 'package:path/path.dart' as path;

void main(List<String> args) async {
  await build(args, (input, output) async {
    final rootPath = path.fromUri(input.packageRoot);
    final pubspec = loadPackagePubspec(rootPath);
    final asset = renderPubspecAsset(pubspec);
    savePubspecAsset(rootPath, asset);
  });
}

String loadPackagePubspec(String rootPath) {
  final pubspecPath = path.join(rootPath, 'pubspec.yaml');
  final file = File(pubspecPath);
  if (!file.existsSync()) {
    throw BuildError(
      message: 'The pubspec.yaml file was not found in the project (expected at ${file.path})',
    );
  }
  return file.readAsStringSync();
}

void savePubspecAsset(String rootPath, String contents) {
  final assetPath = path.joinAll([rootPath, 'lib', 'src', 'assets', 'pubspec.asset.dart']);
  final file = File(assetPath);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  file.writeAsStringSync(contents);
}

String renderPubspecAsset(String contents) {
  return '''
class PubspecAsset {
  static Future<String> load() async => \'\'\'
$contents
\'\'\';
}

''';
}
