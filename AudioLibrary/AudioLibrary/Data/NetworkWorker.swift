//
//  NetworkWorker.swift
//  AudioLibrary
//
//  Created by Dhiya on 24/03/23.
//

import Foundation

protocol AudioLibraryNetworkWorkerTraits {
  func getSongs(onFetch: @escaping (Result<[Song], NetworkError>) -> Void)
}

final class AudioLibraryNetworkWorker: AudioLibraryNetworkWorkerTraits {
  private let networkManager: NetworkManager = .init()
  
  func getSongs(onFetch: @escaping (Result<[Song], NetworkError>) -> Void) {
    networkManager.getResponse(request: .getSongs) { (result: Result<DataContainer<[Song]>, NetworkError>) in
      switch result {
      case .success(let songsModel):
        onFetch(.success(songsModel.data))
      case .failure(let error):
        onFetch(.failure(error))
      }
    }
  }  
}

final class AudioLibraryMockNetworkWorker: AudioLibraryNetworkWorkerTraits {
  func getSongs(onFetch: @escaping (Result<[Song], NetworkError>) -> Void) {
    let songs: [Song] = [
      Song(id: "0", name: "Song 1", audioURL: "https://drive.google.com/uc?export=download&id=16-NMvJH4aJSgDpM66RizWe2qjHOP6n8f"),
      Song(id: "1", name: "Song 2", audioURL: "https://drive.google.com/uc?export=download&id=1N3EW3CeY1v1L1bM4CtO5Fux1CYm5ZTLe")
    ]
    onFetch(.success(songs))
  }
}
