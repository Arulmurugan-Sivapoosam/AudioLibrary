//
//  Model.swift
//  AudioLibrary
//
//  Created by Dhiya on 24/03/23.
//

import Foundation

class Song: Codable {
  internal init(id: String, name: String, audioURL: String) {
    self.id = id
    self.name = name
    self.audioURL = audioURL
  }
  
  let id, name, audioURL: String
 
  var state: State?
  var songLocation: String?
  
  enum State {
    case yetToDownload, downloaded, playing
  }
}
