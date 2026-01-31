import 'package:remote_rift_utils/remote_rift_utils.dart';

import 'version.dart';

class ApiServiceRepository {
  Future<RemoteRiftApiServiceInfo> getServiceInfo() async {
    final version = await ApiServiceVersion().load();
    return RemoteRiftApiServiceInfo(version: version);
  }
}
