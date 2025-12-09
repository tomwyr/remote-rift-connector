import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

extension ClientFactory on Client {
  static Client noCertificateVerification() {
    return IOClient(HttpClient()..badCertificateCallback = (cert, host, port) => true);
  }
}
