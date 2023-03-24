//
//  SongListController.swift
//  AudioLibrary
//
//  Created by Dhiya on 23/03/23.
//

import UIKit

final class SongListController: BaseController {
  
  private let tableView: BaseTable = .init()
  private let getSongs: GetSongsList = .init()
  private var songs: [Song] = []
  
  override func layoutViews() {
    view.addSubview(tableView)
    tableView.alignEdges()
    prepareTable()
  }
  
  private func prepareTable() {
    SongTableCell.register(to: tableView)
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  override func updateData() {
    getSongs.execute(()) { [weak self] response in
      guard let self else {return}
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
    songCell.update(song: songs[indexPath.row])
    return songCell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 90 }
}
