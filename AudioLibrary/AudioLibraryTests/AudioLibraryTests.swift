//
//  AudioLibraryTests.swift
//  AudioLibraryTests
//
//  Created by Dhiya on 23/03/23.
//

import XCTest
@testable import AudioLibrary

final class AudioLibraryTests: XCTestCase {
  
  func testExample() throws {
    FileManagerTests().invokeTest()
    DownloadableTests().invokeTest()
    SongTests().invokeTest()
  }
  
}
