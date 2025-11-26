import Hummingbird

protocol ResponseCodable: Codable, ResponseGenerator {}

extension ResponseCodable {
  func response(from request: Request, context: some RequestContext) throws -> Response {
    var buffer = ByteBuffer()
    try buffer.writeJSONEncodable(self)
    let body = ResponseBody(byteBuffer: buffer)

    return Response(
      status: .ok,
      headers: [.contentType: "application/json"],
      body: body,
    )
  }
}
