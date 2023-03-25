//
//  SongTableCell.swift
//  AudioLibrary
//
//  Created by Arul on 24/03/23.
//

import Foundation
import UIKit
import AVFoundation

final class SongTableCell: BaseTableCell {
  
  private let songNameLabel: UILabel = .init(frame: .zero)
  private let songActionButton: BaseButton = .init()
  private let songCardView: UIView = .init(frame: .zero)
  private let progressView: ProgressView = .init()
  
  private var song: Song?
  var performPlayer: ((AudioPlayer.Action) -> Void)?
  
  func update(song: Song) {
    self.song = song
    songNameLabel.text = song.name
    updateState(of: song)
    listenToDownloadIfNeeded()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    progressView.update(fraction: .zero)
  }
  
  override func layoutViews() {
    contentView.addSubview(songCardView)
    songCardView.alignEdges(offset: 7)
    
    songCardView.addSubview(songNameLabel)
    songNameLabel.align(.top, offset: 10)
    songNameLabel.align(.leading, offset: 10)
    songNameLabel.align(.trailing, offset: 7)
    
    songCardView.addSubview(songActionButton)
    songActionButton.fixSize(.init(width: 70, height: 70))
    songActionButton.align(.trailing, offset: 7)
    songActionButton.align(.bottom, offset: 7)
    
    songCardView.addSubview(progressView)
    progressView.fixSize(.init(width: 50, height: 50))
    progressView.centerHorizontally(with: songActionButton)
    progressView.centerVertically(with: songActionButton)
    progressView.isHidden = true
  }
  
  override func addActions() {
    songActionButton.didPerformTapAction = {
      self.changeState()
    }
  }
  
  override func setColors() {
    songCardView.backgroundColor = UIColor(red: 0.58, green: 0.58, blue: 0.60, alpha: 1.00)
    songNameLabel.textColor = .white
  }
  
  override func updateAttributes() {
    songCardView.layer.cornerRadius = 7
    songNameLabel.font = .systemFont(ofSize: 25)
    selectionStyle = .none
  }
}

// MARK: - State handling
extension SongTableCell {
  func updateState(of song: Song) {
    songActionButton.setImage(.init(named: song.state.icon), for: .normal)
  }
  
  private func changeState() {
    guard let song else {return}
    switch song.state {
    case .yetToDownload:
      song.download()
    case .downloaded, .paused:
      self.song?.state = .playing
      performPlayer?(.play(song))
    case .playing:
      self.song?.state = .paused
      performPlayer?(.pause)
    case .downloading: break
    }
    updateState(of: song)
    listenToDownloadIfNeeded()
  }
  
  private func listenToDownloadIfNeeded() {
    updateProgressViewState()
    guard let song,
      song.state == .downloading else { return }
    update(downloadFraction: song.downloadedFraction)
    song.didDownload = { songData in
      self.updateProgressViewState()
      self.updateState(of: song)
    }
    song.didUpdateFraction = { fraction in
      self.update(downloadFraction: fraction)
    }
  }
  
  private func update(downloadFraction: Float) {
    progressView.update(fraction: downloadFraction)
  }
  
  private func updateProgressViewState() {
    progressView.isHidden = song?.state != .downloading
    songActionButton.isHidden = song?.state == .downloading
  }
}

private extension Song.State {
  var icon: String {
    switch self {
    case .yetToDownload: return "download"
    case .downloaded, .paused: return "play"
    case .playing: return "pause"
    case .downloading: return ""
    }
  }
}
