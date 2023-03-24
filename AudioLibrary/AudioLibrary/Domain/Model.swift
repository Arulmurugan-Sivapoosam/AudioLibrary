//
//  Model.swift
//  AudioLibrary
//
//  Created by Dhiya on 24/03/23.
//

import Foundation

class Song: Decodable {
  let id, name, audioURL: String
  
  var state: State = .yetToDownload
  var songLocation: String = ""
  
  var downloadedFraction: Float = .zero
  var didUpdateFraction: ((Float) -> Void)?
  var didDownload: ((Data?) -> Void)?
  
  private var downloadManager: NetworkDownloadManager?
  
  init(id: String, name: String, audioURL: String) {
    self.id = id
    self.name = name
    self.audioURL = audioURL
  }
  
  enum State: String {
    case yetToDownload, downloading, downloaded, playing
  }
  
  private enum CodingKeys: String, CodingKey {
    case id, name, audioURL
  }
  
  /// Method changes to next state
  func updateState() {
    state = {
      switch state {
      case .yetToDownload:
        self.download()
        return .downloading
      case .downloaded:
        return .playing
      case .playing:
        return .downloaded
      default:
        return state
      }
    }()
  }
}

extension Song {
  func download() {
    downloadManager = .init()
    downloadManager?.didChangeFraction = { fraction in
      self.downloadedFraction = fraction
      self.didUpdateFraction?((fraction))
    }
    
    downloadManager?.didDownload = { songData in
    
    }
    
    downloadManager?.downloadData(from: audioURL)
  }
}
