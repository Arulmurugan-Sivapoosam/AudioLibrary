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
  
  lazy var state: State = {
    fileManagerURL == nil ? .yetToDownload : .downloaded
  }()
  
  /// Get only property returns FileManager URL if songs exists else return nil
  var fileManagerURL: URL? {
    if var docDire = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
      docDire.appendPathComponent("AudioPlayer/\(name)_\(id)")
      return FileManager.default.fileExists(atPath: docDire.path) ? docDire : nil
    }
    return nil
  }
  
  var downloadDelegate: DownloadableDelegate?
  var downloadedFraction: Float = .zero
  
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

extension Song: Downloadable, FileManagerWritable, DownloadableDelegate {
  func didDownload(fraction: Float) {
    downloadedFraction = fraction
    downloadDelegate?.didDownload(fraction: fraction)
  }
  
  func didCompleteDownloading(data: Data) {
    self.state = .downloaded
    if var folderURL = createFolder(named: "AudioPlayer", in: .documentDirectory) {
      folderURL.appendPathComponent(name + "_" + id)
      write(data: data, at: folderURL)
    }
    downloadDelegate?.didCompleteDownloading(data: data)
  }
  
  func download() {
    self.state = .downloading
    download(song: self, downloadDelegate: self)
  }
}

// MARK: - FileManagerWritable
protocol FileManagerWritable { }
extension FileManagerWritable {
  func write(data: Data, at location: URL) {
    if !FileManager.default.fileExists(atPath: location.path) {
      try? data.write(to: location)
    }
  }
  
  func createFolder(named folderName: String, in parentDirectory: FileManager.SearchPathDirectory) -> URL? {
    guard let directoryURL = FileManager.default.urls(for: parentDirectory, in: .userDomainMask).first else {return nil}
    let folderURL = directoryURL.appendingPathComponent(folderName)
    do {
      if !FileManager.default.fileExists(atPath: folderURL.path) {
        try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
      }
      return folderURL
    } catch { return nil }
  }
}

// MARK: - Downloadable Protocol
protocol DownloadableDelegate: AnyObject {
  func didDownload(fraction: Float)
  func didCompleteDownloading(data: Data)
}

protocol Downloadable { }

extension Downloadable {
  func download(song: Song, downloadDelegate: DownloadableDelegate) {
    let downloadManager = NetworkDownloadManager(delegate: downloadDelegate)
    downloadManager.downloadData(from: song.audioURL)
  }
}

// MARK: - Audio Player
final class AudioPlayer {
  private var player: AVAudioPlayer?
  private var currentlyPlaying: Song?
}

extension AudioPlayer {
  private func play(song: Song) {
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback)
      try AVAudioSession.sharedInstance().setActive(true)
      if currentlyPlaying?.id != song.id,
         let songPath = song.fileManagerURL {
        self.player = try AVAudioPlayer(contentsOf: .init(fileURLWithPath: songPath.path))
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
