//
//  QuizModel.swift
//  MARU
//
//  Created by psychehose on 2021/04/10.
//

import Foundation

struct QuizModel: Codable {
  let quiz: [Quiz]
}
struct Quiz: Codable {
  let quizContent: String
  let quizAnswer: String
}
