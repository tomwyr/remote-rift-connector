import Foundation

struct HttpClient {
  public init(baseUrl: String? = nil, session: URLSession = .shared) {
    self.baseUrl = baseUrl
    self.session = session
  }

  let baseUrl: String?
  let session: URLSession

  public func request(
    url: String,
    method: HttpMethod = .get,
    headers: [String: String] = [:],
    body: [String: String]? = nil
  ) async throws -> (Data, HTTPURLResponse) {
    let urlString = if let baseUrl { baseUrl + url } else { url }
    guard let requestUrl = URL(string: urlString) else {
      throw URLError(.badURL)
    }

    var request = URLRequest(url: requestUrl)
    request.httpMethod = method.rawValue
    headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

    if let body {
      let bodyString = body.map { "\($0)=\($1)" }.joined(separator: "&")
      request.httpBody = bodyString.data(using: .utf8)
    }

    let (data, response) = try await session.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse else {
      throw URLError(.badServerResponse)
    }

    return (data, httpResponse)
  }
}

public enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

extension HTTPURLResponse {
  public var isSuccessful: Bool {
    200..<300 ~= statusCode
  }
}

extension Data {
  public func jsonDecoded<T: Codable>(
    into: T.Type = T.self,
    keyStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
  ) throws -> T {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = keyStrategy
    return try decoder.decode(T.self, from: self)
  }
}

extension HttpClient {
  static func noCertificateVerification() -> HttpClient {
    let delegate = NoCertificateVerificationDelegate()
    let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
    return HttpClient(session: session)
  }
}

private final class NoCertificateVerificationDelegate: NSObject, URLSessionDelegate {
  func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
  ) {
    completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
  }
}
