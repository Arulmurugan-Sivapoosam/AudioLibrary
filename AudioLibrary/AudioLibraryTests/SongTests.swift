//
//  GetSongTests.swift
//  AudioLibraryTests
//
//  Created by Arul on 26/03/23.
//

import Foundation
import XCTest
@testable import AudioLibrary

final class SongTests: XCTestCase {
  
  private lazy var getSongs: GetSongsList = .init()
  
  override func invokeTest() {
    testGetSongsAPI()
  }
  
  func testGetSongsAPI() {
    let promise = expectation(description: "Downloading Songs")
    getSongs.execute(()) { response in
      switch response {
      case .network(let songs), .local(let songs):
        XCTAssertFalse(songs.isEmpty)
        promise.fulfill()
      case .failure:
        XCTFail("Error when downloading songs")
      }
    }
    wait(for: [promise], timeout: 5)
  }
}
