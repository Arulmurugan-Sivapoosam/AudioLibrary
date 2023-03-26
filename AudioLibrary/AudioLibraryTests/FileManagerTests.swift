//
//  FileManagerTests.swift
//  AudioLibraryTests
//
//  Created by Arul on 26/03/23.
//

import XCTest
@testable import AudioLibrary

final class FileManagerTests: XCTestCase, FileManagerWritable {
  override func invokeTest() {
    testFolderCreation()
    testFileCreation()
  }
  
  func testFolderCreation() {
    let folderURL = createFolder(named: "Test_Folder", in: .documentDirectory)
    XCTAssertNotNil(folderURL)
    testIsFolderExists("Test_Folder", in: .documentDirectory)
  }
  
  func testIsFolderExists(_ folderName: String, in parentDirectory: FileManager.SearchPathDirectory) {
    if var parentDirectory = FileManager.default.urls(for: parentDirectory, in: .userDomainMask).first {
      parentDirectory.appendPathComponent(folderName)
      XCTAssertTrue(FileManager.default.fileExists(atPath: parentDirectory.path))
    } else {
      XCTFail("Parent directory not found")
    }
  }
  
  func testFileCreation() {
    if let songURL = Bundle.main.url(forResource: "Song 1", withExtension: "mp3"),
       var fileManagerURL = createFolder(named: "Test_Folder", in: .documentDirectory) {
      fileManagerURL.append(component: "Song 1")
      write(data: songURL.dataRepresentation, at: fileManagerURL)
      XCTAssertTrue(FileManager.default.fileExists(atPath: fileManagerURL.path))
    } else {
      XCTFail("Song not found")
    }
  }
}
