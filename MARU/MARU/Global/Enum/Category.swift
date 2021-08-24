//
//  Category.swift
//  MARU
//
//  Created by psychehose on 2021/08/23.
//
enum Category {
  case all
  case art
  case literal
  case language
  case philosophy
  case socialScience
  case pureScience
  case technicalScience
  case history
  case religion
  case etc

  func simpleDescription() -> String {
    switch self {
    case .all: return "전체"
    case .art: return "예술"
    case .literal: return "문학"
    case .language: return "어학"
    case .philosophy: return "철학/심리학/윤리학"
    case .socialScience: return "사회과학"
    case .pureScience: return "순수과학"
    case .technicalScience: return "기술과학"
    case .history: return "역사/지리/관광"
    case .religion: return "종교"
    case .etc: return "그 외"
    }
  }
}
