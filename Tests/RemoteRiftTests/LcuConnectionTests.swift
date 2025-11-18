import Foundation
import Testing

@testable import RemoteRiftConnector

@Test func parseValidLockfile() async throws {
  let connection = setUpConnection(
    lockfile: "LeagueClient:4739:64831:92vPaOjpGk5JdXIbMVHAgA:https",
  )
  let data = try await connection.getLockfileData()
  let expected = LcuLockfileData(port: 64831, password: "92vPaOjpGk5JdXIbMVHAgA")
  #expect(data == expected)
}

@Test func parseLockfileWithInvalidPort() async throws {
  let connection = setUpConnection(
    lockfile: "LeagueClient:4739:64abc:92vPaOjpGk5JdXIbMVHAgA:https",
  )
  await #expect {
    try await connection.getLockfileData()
  } throws: { err in
    guard let err = err as? LcuConnectionError else { return false }
    return err == .lockfileInvalid
  }
}

@Test func parseLockfileWithMissingSegment() async throws {
  let connection = setUpConnection(
    lockfile: "4739:64831:92vPaOjpGk5JdXIbMVHAgA:https",
  )
  await #expect {
    try await connection.getLockfileData()
  } throws: { err in
    guard let err = err as? LcuConnectionError else { return false }
    return err == .lockfileInvalid
  }
}

private func setUpConnection(lockfile: String) -> LcuConnection {
  let loader = TestLockfileLoader(result: lockfile)
  return LcuConnection(loader: loader)
}

class TestLockfileLoader: LockfileLoader {
  init(result: String) {
    self.result = result
  }

  let result: String

  func loadLockfile() throws -> String {
    result
  }
}
