//
//  SongTableCell.swift
//  AudioLibrary
//
//  Created by Arul on 24/03/23.
//

import Foundation
import UIKit

final class SongTableCell: BaseTableCell {
  
  private let songNameLabel: UILabel = .init(frame: .zero)
  private let songActionButton: BaseButton = .init()
  private let songCardView: UIView = .init(frame: .zero)
  
  private var song: Song?
  
  func update(song: Song) {
    self.song = song
    songNameLabel.text = song.name
  }
  
  override func layoutViews() {
    addSubview(songCardView)
    songCardView.alignEdges(offset: 7)
    
    songCardView.addSubview(songNameLabel)
    songNameLabel.align(.top, offset: 10)
    songNameLabel.align(.leading, offset: 10)
    songNameLabel.align(.trailing, offset: 7)
    
    songCardView.addSubview(songActionButton)
    songActionButton.fixSize(.init(width: 70, height: 70))
    songActionButton.align(.trailing, offset: 7)
    songActionButton.align(.bottom, offset: 7)
  }
  
  override func addActions() {
    songActionButton.didPerformTapAction = {
      
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
