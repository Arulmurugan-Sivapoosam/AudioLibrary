//
//  DataManager.swift
//  AudioLibrary
//
//  Created by Dhiya on 24/03/23.
//

import Foundation

// MARK: - Layer to acess local, network service based on the request.
protocol DataManagerTraits {
  func getSongs(onFetch: @escaping (Response<[Song]>) -> Void)
}

// MARK: - Default DataManager which access local and network worker.
final class AudioLibraryDataManager: DataManagerTraits {
  private let network: AudioLibraryNetworkWorkerTraits = AudioLibraryNetworkWorker()
  private let local: AudioLibraryLocalWorkerTraits = AudioLibraryLocalWorker()
  
  func getSongs(onFetch: @escaping (Response<[Song]>) -> Void) {
    local.getSongs { result in
      if case Result.success(let songs) = result {
        onFetch(.local(songs))
      }
    }
    network.getSongs { result in
      if case Result.success(let songs) = result {
        SongsCoreDataHelper().save(songs: songs)
      }
      onFetch(result.convert())
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

struct DataContainer<NestedData: Decodable>: Decodable {
  let data: NestedData
}

// MARK: - Testable mock data manager
final class AudioLibraryMockDataManager: DataManagerTraits {
  func getSongs(onFetch: @escaping (Response<[Song]>) -> Void) {
    let songs: [Song] = [
      Song(id: "0", name: "Song 1", audioURL: "https://drive.google.com/uc?export=download&id=16-NMvJH4aJSgDpM66RizWe2qjHOP6n8f"),
      Song(id: "1", name: "Song 2", audioURL: "https://drive.google.com/uc?export=download&id=1N3EW3CeY1v1L1bM4CtO5Fux1CYm5ZTLe")
    ]
    onFetch(.network(songs))
  }
}
