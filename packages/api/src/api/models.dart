enum RemoteRiftStatus {
  ready,
  unavailable;

  Map<String, dynamic> toJson() => throw UnimplementedError();
}

typedef RemoteRiftStatusResponse = RemoteRiftResponse<RemoteRiftStatus>;

sealed class RemoteRiftState {
  Map<String, dynamic> toJson() => throw UnimplementedError();
}

class PreGame extends RemoteRiftState {}

class Lobby extends RemoteRiftState {
  Lobby({required this.state});

  final GameLobbyState state;
}

class Found extends RemoteRiftState {
  Found({required this.state});

  final GameFoundState state;
}

class InGame extends RemoteRiftState {}

class Unknown extends RemoteRiftState {}

enum GameLobbyState { idle, searching }

enum GameFoundState { pending, accepted, declined }

sealed class RemoteRiftResponse<T> {
  Map<String, dynamic> toJson() => throw UnimplementedError();
}

class RemoteRiftData<T> extends RemoteRiftResponse<T> {
  RemoteRiftData(this.value);

  final T value;
}

enum RemoteRiftError<T extends Never> implements RemoteRiftResponse<T> {
  unableToConnect,
  unknown;

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}
