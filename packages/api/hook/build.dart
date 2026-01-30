import 'dart:io';

import 'package:hooks/hooks.dart';
import 'package:path/path.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final rootPath = input.packageRoot.path;
    final pubspec = loadPackagePubspec(rootPath);
    final asset = renderPubspecAsset(pubspec);
    savePubspecAsset(rootPath, asset);
  });
}

String loadPackagePubspec(String rootPath) {
  final path = join(rootPath, 'pubspec.yaml');
  final file = File(path);
  if (!file.existsSync()) {
    throw BuildError(message: 'The pubspec.yaml file was not found in the project');
  }
  return file.readAsStringSync();
}

void savePubspecAsset(String rootPath, String contents) {
  final path = joinAll([rootPath, 'lib', 'src', 'assets', 'pubspec.asset.dart']);
  final file = File(path);
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
