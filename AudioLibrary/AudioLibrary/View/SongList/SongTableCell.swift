//
//  SongTableCell.swift
//  AudioLibrary
//
//  Created by Arul on 24/03/23.
//

import Foundation
import UIKit

final class SongTableCell: BaseTableCell {
  
  private let songNameLabel: BaseLabel = .init(labelType: .primary)
  private let songActionButton: BaseButton = .init()
  
  private var song: Song?
  
  func update(song: Song) {
    self.song = song
    songNameLabel.text = song.name
  }
  
  override func layoutViews() {
    addSubview(songNameLabel)
    songNameLabel.align(.top)
    songNameLabel.align(.leading, offset: 7)
    songNameLabel.align(.trailing, offset: 7)
    
    addSubview(songActionButton)
    songActionButton.fixSize(.init(width: 70, height: 70))
    songActionButton.align(.trailing, offset: 7)
    songActionButton.align(.bottom, offset: 7)
  }
  
  override func addActions() {
    songActionButton.didPerformTapAction = {
      
    }
  }
}
