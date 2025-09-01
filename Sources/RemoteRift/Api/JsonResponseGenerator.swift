import Hummingbird

extension ResponseGenerator {
  static func json<T: Encodable>(_ value: T) -> ResponseGenerator {
    JsonResponseGenerator(value: value)
  }
}

struct JsonResponseGenerator<T: Encodable>: ResponseGenerator {
  let value: T

  func response(from request: Request, context: some RequestContext) throws -> Response {
    var buffer = ByteBuffer()
    try buffer.writeJSONEncodable(value)
    let body = ResponseBody(byteBuffer: buffer)

    return Response(
      status: .ok,
      headers: [.contentType: "application/json"],
      body: body,
    )
  }
}
