sealed class RemoteRiftApiConfigSource {
  factory RemoteRiftApiConfigSource.environment() = EnvironmentSource;
  factory RemoteRiftApiConfigSource.systemLookup({SystemLookupAddressResolver? resolveAddress}) =
      SystemLookupSource;
}

class EnvironmentSource implements RemoteRiftApiConfigSource {}

typedef SystemLookupAddressResolver = String Function(List<String> availableAddresses);

class SystemLookupSource implements RemoteRiftApiConfigSource {
  final SystemLookupAddressResolver? resolveAddress;

  SystemLookupSource({this.resolveAddress});
}
