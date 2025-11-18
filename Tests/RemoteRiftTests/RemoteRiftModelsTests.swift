import Foundation
import Testing

@testable import RemoteRiftConnector

@Test func stateResponseSerialization() async throws {
  func testResponse(json: String, value: RemoteRiftStateResponse) throws {
    let decodedValue = try jsonToObject(RemoteRiftStateResponse.self, json)
    #expect(decodedValue == value)

    let jsonDict = try jsonToDict(json)
    let valueDict = try objectToJsonDict(value)
    #expect(jsonDict == valueDict)
  }

  try testResponse(
    json: #"{"type":"error","value":"unableToConnect"}"#,
    value: .error(.unableToConnect),
  )
  try testResponse(
    json: #"{"type":"error","value":"unknown"}"#,
    value: .error(.unknown),
  )
  try testResponse(
    json: #"{"type":"data","value":"inGame"}"#,
    value: .data(.inGame),
  )
  try testResponse(
    json: #"{"type":"data","value":"found","state":"accepted"}"#,
    value: .data(.found(state: .accepted)),
  )
}
