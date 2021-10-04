//
//  GroupInformation.swift
//  MARU
//
//  Created by 이윤진 on 2021/10/04.
//

struct GroupInformation: Codable {
  let discussionGroupID: Int
  let description: String
  let createdAt: String
  let remainingDay: Int
  let title: String
  let image: String
  let author: String
  let classes: JSONNull?
  let nickname: String
  let leaderScore: Int
  let userCount: Int
  let possibleIntoGroup: Bool

  enum CodingKeys: String, CodingKey {
    case discussionGroupID = "discussionGroupID"
    case description = "description"
    case createdAt, remainingDay, title, image, author, classes, nickname, leaderScore, userCount, possibleIntoGroup
  }
}

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
