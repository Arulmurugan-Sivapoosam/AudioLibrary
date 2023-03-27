//
//  AudioLibraryUITests.swift
//  AudioLibraryUITests
//
//  Created by Dhiya on 23/03/23.
//

import XCTest

final class AudioLibraryUITests: XCTestCase {
  
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  func testExample() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launchArguments = ["isUITesting"]
    app.launch()
    testIsSongRowExists(on: app)
  }
  
  func testIsSongRowExists(on app: XCUIApplication) {
    XCTAssert(app.staticTexts["Song 1"].exists)
    XCTAssert(app.staticTexts["Song 2"].exists)
  }
}
