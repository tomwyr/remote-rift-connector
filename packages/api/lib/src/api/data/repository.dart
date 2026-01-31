import 'models.dart';
import 'version.dart';

class ApiServiceRepository {
  Future<RemoteRiftApiServiceInfo> getInfo() async {
    final version = await ApiServiceVersion().load();
    return RemoteRiftApiServiceInfo(version: version);
  }
}
