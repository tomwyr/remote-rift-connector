import Foundation
import Testing

func jsonToDict(_ json: String) throws -> NSDictionary {
  let data = try #require(json.data(using: .utf8))
  let object = try JSONSerialization.jsonObject(with: data)
  return try #require(object as? NSDictionary)
}

func jsonToObject<T>(_ type: T.Type, _ json: String) throws -> T where T: Decodable {
  let data = try #require(json.data(using: .utf8))
  return try JSONDecoder().decode(T.self, from: data)
}

func objectToJsonDict(_ object: Encodable) throws -> NSDictionary {
  let data = try JSONEncoder().encode(object)
  let json = try #require(String(data: data, encoding: .utf8))
  return try jsonToDict(json)
}

func jsonValueToObject<T>(_ type: T.Type, json: String) throws -> T where T: Decodable {
  let data = try #require(json.data(using: .utf8))
  return try JSONDecoder().decode(T.self, from: data)
}

func objectToJsonValue(_ object: Encodable) throws -> String {
  let data = try JSONEncoder().encode(object)
  return try #require(String(data: data, encoding: .utf8))
}
