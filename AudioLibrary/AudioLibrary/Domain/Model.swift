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
  
  init(id: String, name: String, audioURL: String) {
    self.id = id
    self.name = name
    self.audioURL = audioURL
  }
  
  enum State: String {
    case yetToDownload, downloaded, playing
  }
  
  private enum CodingKeys: String, CodingKey {
    case id, name, audioURL
  }
}
