//
//  MARUTests.swift
//  MARUTests
//
//  Created by 오준현 on 2021/03/27.
//

import XCTest

@testable import MARU

class MARUTests: XCTestCase {
  var testQuizViewModel = QuizViewModel()
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    testQuizViewModel = QuizViewModel()
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
  func testQuiz1() {
    let result = testQuizViewModel.checkAnswer(quizAnswer: "O", users: "X")
    XCTAssertEqual(result, false, "incorrect")
  }
  func testQuiz2() {
    let result = testQuizViewModel.checkAnswer(quizAnswer: "O", users: "O")
    XCTAssertEqual(result, true, "Cincorrect")
  }
  func testQuiz3() {
    let result = testQuizViewModel.checkAnswer(quizAnswer: "X", users: "O")
    XCTAssertEqual(result, false, "incorrect")
  }
  func testQuiz4() {
    let result = testQuizViewModel.checkAnswer(quizAnswer: "X", users: "X")
    XCTAssertEqual(result, true, "incorrect")
  }

}
