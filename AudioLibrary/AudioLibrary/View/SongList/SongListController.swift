//
//  SongListController.swift
//  AudioLibrary
//
//  Created by Dhiya on 23/03/23.
//

import UIKit

final class SongListController: BaseController {
  
  private let tableView: BaseTable = .init()
  private let loader: UIActivityIndicatorView = .init(style: .large)
  
  private let getSongs: GetSongsList = .init()
  private var songs: [Song] = []
  
  override var navigationTitle: String? {"Songs"}
  private lazy var audioPlayer: AudioPlayer = .init()
  private var currentPlayingIndex: Int = .zero {
    didSet {
      guard currentPlayingIndex != oldValue else {return}
      let previouslyPlayedSong = songs[oldValue]
      if previouslyPlayedSong.state == .playing {
        previouslyPlayedSong.state = .paused
        let cell = tableView.cellForRow(at: .init(row: oldValue, section: .zero)) as? SongTableCell
        cell?.updateState(of: previouslyPlayedSong)
      }
    }
  }
  
  override func layoutViews() {
    view.addSubview(tableView)
    tableView.alignEdges()
    prepareTable()
  }
  
  private func prepareTable() {
    SongTableCell.register(to: tableView)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
  }
  
  override func prepareNavigation() {
    super.prepareNavigation()
    navigationItem.rightBarButtonItem = .init(customView: loader)
  }
  
  override func updateData() {
//    self.songs = [
//      Song(id: "0", name: "song 1", audioURL: "https://drive.google.com/uc?export=download&id=1vGk9m-A5JZZCgc23imDOfVfIPFOLVQcj"),
//      Song(id: "1", name: "song 2", audioURL: "https://drive.google.com/uc?export=download&id=1_4k-awx3oEI_iHF38pKcbIAkRpXF_3Sb"),
//      Song(id: "2", name: "song 3", audioURL: "https://drive.google.com/uc?export=download&id=1Ry36i7KBSHzZuSrSHrVXgNG0o-iqGP3v"),
//      Song(id: "3", name: "song 4", audioURL: "https://drive.google.com/uc?export=download&id=1BNmjLCyGd36p_pH_z7Ls9hSjP9-m2lR2")
//    ]
    loader.startAnimating()
    getSongs.execute(()) { [weak self] response in
      guard let self else {return}
      self.loader.stopAnimating()
      switch response {
      case .network(let songs), .local(let songs):
        self.songs = songs
      case .failure(let error):
        self.songs = []
        self.show(error: error)
      }
      self.tableView.reloadData()
    }
  }
  
  func show(error: Error) {
    
  }
}

extension SongListController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { songs.count }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let songCell: SongTableCell = tableView.dequeueReusableCell(for: indexPath)
    songCell.performPlayer = { [weak self] playerAction in
      if case AudioPlayer.Action.play = playerAction {
        self?.currentPlayingIndex = indexPath.row
      }
      self?.audioPlayer.perform(action: playerAction)
    }
    songCell.update(song: songs[indexPath.row])
    return songCell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 170 }
}
