//
//  SongsCoreDataHelper.swift
//  AudioLibrary
//
//  Created by Arul on 25/03/23.
//

import Foundation

final class SongsCoreDataHelper: CoreDataStorable {
  typealias CoreDataType = LocalSong
  
  func save(songs: [Song]) {
    songs.enumerated().forEach { iterator in
      save(song: iterator.element, position: iterator.offset)
    }
  }
  
  private func save(song: Song, position: Int) {
    var localSong: LocalSong?
    object(withPredicate: .init(format: "id==%@", song.id), onFetch: { result in
      if let storedSong = try? result.get() {
        localSong = storedSong
      } else {
        localSong = self.insertNewEntity()
      }
      guard let localSong else {return}
      localSong.id = song.id
      localSong.name = song.name
      localSong.position = Int64(position)
      localSong.songURL = song.audioURL
      localSong.localPath = localSong.localPath ?? song.songLocation
      self.saveContext()
    })
  }
  
  func update(songLocalPath: String, to song: Song) {
    update(\.localPath, value: songLocalPath, where: .init(format: "id == %@", song.id)) { result in
      if case Result.failure(let error) = result {
        print("failed to writed songpath", error.localizedDescription)
      }
    }
  }
  
  func getSongs(onFetch: @escaping (Result<[Song], CoreDataError>) -> Void) {
    let songSorter = NSSortDescriptor(key: "position", ascending: true)
    dataModels(with: nil, sorterDescriptor: [songSorter], transform: {Song(coreDataModel: $0)}, onFetch: onFetch)
  }
}

private extension Song {
  convenience init(coreDataModel: LocalSong) {
    self.init(
      id: coreDataModel.id.safelyUnwrap,
      name: coreDataModel.name.safelyUnwrap,
      audioURL: coreDataModel.songURL.safelyUnwrap
    )
    self.songLocation = coreDataModel.localPath.safelyUnwrap
    self.state = self.songLocation.isEmpty ? .yetToDownload : .downloaded
  }
}
