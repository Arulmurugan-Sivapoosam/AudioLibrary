//
//  DownloadableTests.swift
//  AudioLibraryTests
//
//  Created by Arul on 26/03/23.
//

import Foundation
import XCTest
@testable import AudioLibrary

final class DownloadableTests: XCTestCase, Downloadable {
  
  override func invokeTest() {
    super.invokeTest()
    testSongDownload()
  }
  
  func testSongDownload() {
    let song = Song(id: "0", name: "Song 5", audioURL: "https://drive.google.com/uc?export=download&id=16-NMvJH4aJSgDpM66RizWe2qjHOP6n8f")
    let mockModel = MockDownloadableModel(song: song)
    let promise = expectation(description: "Song is downloaded")
    mockModel.startDownload {
      promise.fulfill()
    }
    XCTAssertEqual(song.state, .downloading)
    wait(for: [promise], timeout: 5)
    XCTAssertEqual(song.state, .downloaded)
    XCTAssertEqual(song.downloadedFraction, 1)
  }
}

class MockDownloadableModel: DownloadableDelegate {
  private let song: Song
  private var closure: (() -> Void)?
  init(song: Song) {
    self.song = song
  }
  
  func startDownload(onDownload: @escaping () -> Void) {
    self.closure = onDownload
    song.downloadDelegate = self
    song.download()
  }
  
  func didDownload(fraction: Float) { }
  
  func didCompleteDownloading(data: Data) {
    closure?()
  }
}

