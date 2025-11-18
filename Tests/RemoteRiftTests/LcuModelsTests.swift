import Foundation
import Testing

@testable import RemoteRiftConnector

@Test func gameflowPhaseSerialization() async throws {
    func testPhase(json: String, value: GameflowPhase) throws {
        let decoded = try jsonValueToObject(GameflowPhase.self, json: json)
        #expect(decoded == value)

        let encoded = try objectToJsonValue(value)
        #expect(encoded == json)
    }

    try testPhase(json: #""Lobby""#, value: .lobby)
    try testPhase(json: #""ReadyCheck""#, value: .readyCheck)
    try testPhase(json: #""ChampSelect""#, value: .champSelect)
    try testPhase(json: #""PreEndOfGame""#, value: .preEndOfGame)
}
