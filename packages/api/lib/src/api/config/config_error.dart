import 'config.dart';

sealed class RemoteRiftApiConfigError implements Exception {}

extension on RemoteRiftApiConfigError {
  String get _hostKey => RemoteRiftApiConfig.envHostKey;
  String get _portKey => RemoteRiftApiConfig.envPortKey;
}

class AddressHostMissing implements RemoteRiftApiConfigError {
  @override
  String toString() => '$_hostKey must be provided';
}

class AddressPortMissing implements RemoteRiftApiConfigError {
  @override
  String toString() => '$_portKey must be provided';
}

class AddressPortInvalid implements RemoteRiftApiConfigError {
  AddressPortInvalid({required this.input});

  final String input;

  @override
  String toString() => 'Invalid $_portKey: "$input"';
}

sealed class AddressLookupError implements Exception {}

class AddressNotFound implements RemoteRiftApiConfigError, AddressLookupError {
  @override
  String toString() => 'No IPv4 network is connected';
}

class MultipleAddressesFound implements RemoteRiftApiConfigError, AddressLookupError {
  @override
  String toString() => 'Multiple IPv4 networks are connected';
}
