//
//  Model.swift
//  AudioLibrary
//
//  Created by Dhiya on 24/03/23.
//

import Foundation
import AVFoundation
import UIKit

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
    case yetToDownload, downloading, downloaded, playing, paused
  }
  
  private enum CodingKeys: String, CodingKey {
    case id, name, audioURL
  }
}

extension Song {
  func download() {
    self.state = .downloading
    downloadManager = .init()
    downloadManager?.didChangeFraction = { fraction in
      self.downloadedFraction = fraction
      self.didUpdateFraction?((fraction))
    }
    
    downloadManager?.didDownload = { songData in
      self.save(song: songData)
      self.state = .downloaded
      self.didDownload?(songData)
    }
    
    downloadManager?.downloadData(from: audioURL)
  }
  
  func save(song: Data?) {
    guard let song else {return}
    guard let documentDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
    let appInternalMusic = documentDirURL.appendingPathComponent("AudioPlayer")
    do {
      if !FileManager.default.fileExists(atPath: appInternalMusic.path) {
        try FileManager.default.createDirectory(at: appInternalMusic, withIntermediateDirectories: true, attributes: nil)
      }
      let songDestinationURL = appInternalMusic.appendingPathComponent(name)
      try song.write(to: songDestinationURL)
      self.songLocation = songDestinationURL.path
      SongsCoreDataHelper().update(songLocalPath: self.songLocation, to: self)
    } catch let error {
      print("Eror when writing songs", error.localizedDescription)
    }
  }
}

final class AudioPlayer {
  private var player: AVAudioPlayer?
  private var currentlyPlaying: Song?
}

extension AudioPlayer {
  private func play(song: Song) {
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback)
      try AVAudioSession.sharedInstance().setActive(true)
      if currentlyPlaying?.id != song.id {
        self.player = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: song.songLocation))
      }
      guard let player else {return}
      player.play()
      currentlyPlaying = song
    } catch let error {
      print("Error when playing song: \(song.name)", error.localizedDescription)
    }
  }
  
  func perform(action: Action) {
    switch action {
    case .play(let song):
      play(song: song)
    case .pause:
      player?.pause()
    }
  }
  
  enum Action {
    case play(Song)
    case pause
  }
}
