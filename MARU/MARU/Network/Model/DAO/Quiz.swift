//
//  Quiz.swift
//  MARU
//
//  Created by psychehose on 2021/08/21.
//

struct Quiz: Codable {
  let content: String
  let answer: String
}

struct Quizzes: Codable {
  let quizzes: [Quiz]

  init(from decoder: Decoder) throws {
       let keyMap = [
         "quizzes": ["quizAndAnswer"]
       ]
       let container = try decoder.container(keyedBy: AnyKey.self)
       self.quizzes = try container.decode([Quiz].self, forMappedKey: "quizzes", in: keyMap)
     }
}
struct CheckQuiz: Codable {
  let isEnterGroup: Bool
}
