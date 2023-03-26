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
    let coreDataPromise = expectation(description: "Downloading data from local")
    let networkPromise = expectation(description: "Downloading data from service")
    getSongs.execute(()) { response in
      switch response {
      case .network(let songs):
        XCTAssertFalse(songs.isEmpty)
        networkPromise.fulfill()
      case .local(let songs):
        XCTAssertFalse(songs.isEmpty)
        coreDataPromise.fulfill()
      case .failure:
        XCTFail("Error when downloading songs")
      }
    }
    wait(for: [coreDataPromise, networkPromise], timeout: 5)
  }
}
