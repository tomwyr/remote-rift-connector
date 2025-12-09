import 'models.dart';

abstract interface class RemoteRiftConnector {
  factory RemoteRiftConnector() => throw UnimplementedError();

  Stream<RemoteRiftResponse<RemoteRiftStatus>> getStatusStream();
  Stream<RemoteRiftState> getCurrentSateStream();
  Future<RemoteRiftState> getCurrentState();
  Future<void> createLobby();
  Future<void> leaveLobby();
  Future<void> searchMatch();
  Future<void> stopMatchSearch();
  Future<void> acceptMatch();
  Future<void> declineMatch();
}
