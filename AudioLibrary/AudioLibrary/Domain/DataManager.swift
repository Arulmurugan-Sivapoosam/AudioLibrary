//
//  DataManager.swift
//  AudioLibrary
//
//  Created by Dhiya on 24/03/23.
//

import Foundation

// MARK: - Layer to acess local, network service based on the request.
protocol DataManagerTraits {
  var network: AudioLibraryNetworkWorkerTraits {get}
  var local: AudioLibraryLocalWorkerTraits {get}
  
  func getSongs(onFetch: @escaping (Response<[Song]>) -> Void)
  func downloadSong(withURL songURL: URL, onDownload: @escaping (Response<Data>) -> Void)
}

// MARK: - Default DataManager which access local and network worker.
final class AudioLibraryDataManager: DataManagerTraits {
  var network: AudioLibraryNetworkWorkerTraits = AudioLibraryNetworkWorker()
  var local: AudioLibraryLocalWorkerTraits = AudioLibraryLocalWorker()
  
  func getSongs(onFetch: @escaping (Response<[Song]>) -> Void) {
    local.getSongs { result in
      if case Result.success(let songs) = result {
        onFetch(.local(songs))
      }
    }
    network.getSongs { result in
      onFetch(result.convert())
    }
  }
  
  func downloadSong(withURL songURL: URL, onDownload: @escaping (Response<Data>) -> Void) {
    local.downloadSong(withURL: songURL) { result in
      if case Result.success(let song) = result {
        onDownload(.local(song))
      }
    }
    network.downloadSong(withURL: songURL) { result in
      onDownload(result.convert())
    }
  }
}


extension Result {
  func convert() -> Response<Success> {
    switch self {
    case .success(let success): return .network(success)
    case .failure(let failure): return .failure(failure)
    }
  }
}

struct DataContainer<NestedData: Codable>: Decodable {
  let data: NestedData
}
