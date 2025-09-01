import Foundation
import Testing

@testable import RemoteRift

@Test func gameflowPhaseSerialization() async throws {
    func testPhase(json: String, value: GameflowPhase) throws {
        let dataToJson = "\"\(json)\"".data(using: .utf8)!
        let phase = try JSONDecoder().decode(GameflowPhase.self, from: dataToJson)
        assert(phase == value)

        let dataFromJson = try JSONEncoder().encode(phase)
        let phaseJson = String(data: dataFromJson, encoding: .utf8)
        assert(phaseJson == "\"\(json)\"")
    }

    try testPhase(json: "Lobby", value: .lobby)
    try testPhase(json: "ReadyCheck", value: .readyCheck)
    try testPhase(json: "ChampSelect", value: .champSelect)
    try testPhase(json: "PreEndOfGame", value: .preEndOfGame)
}
