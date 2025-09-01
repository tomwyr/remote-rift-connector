import Foundation

struct LcuConnection {
  init(
    parser: LockfileParser = LcuLockfileParser(),
    loader: LockfileLoader = LcuLockfileLoader(),
  ) {
    self.parser = parser
    self.loader = loader
  }

  private let parser: LockfileParser
  private let loader: LockfileLoader

  func getLockfileData() throws -> LcuLockfileData {
    try parser.parseLockfile(from: try loader.loadLockfile())
  }
}

struct LcuLockfileData: Equatable {
  let port: Int
  let password: String
}

enum LcuConnectionError: Error {
  case lockfileMissing
  case lockfileInvalid
}

protocol LockfileParser {
  func parseLockfile(from data: String) throws -> LcuLockfileData
}

class LcuLockfileParser: LockfileParser {
  func parseLockfile(from data: String) throws -> LcuLockfileData {
    let regex = /^(.+):(\d+):(?<port>\d+):(?<password>.*):(.*)$/
    guard let result = data.wholeMatch(of: regex)?.output else {
      throw LcuConnectionError.lockfileInvalid
    }
    return LcuLockfileData(
      port: Int(result.port)!,
      password: String(result.password),
    )
  }
}

protocol LockfileLoader {
  func loadLockfile() throws -> String
}

class LcuLockfileLoader: LockfileLoader {
  func loadLockfile() throws -> String {
    let path = getPlatformPath()
    guard FileManager.default.fileExists(atPath: path) else {
      throw LcuConnectionError.lockfileMissing
    }
    return try String(contentsOfFile: path, encoding: .utf8)
  }

  private func getPlatformPath() -> String {
    #if os(Windows)
      "C:\\Riot Games\\League of Legends\\lockfile"
    #elseif os(macOS)
      "/Applications/League of Legends.app/Contents/LoL/lockfile"
    #else
      fatalError("Unsupported platform — only Windows and macOS are supported.")
    #endif
  }
}
