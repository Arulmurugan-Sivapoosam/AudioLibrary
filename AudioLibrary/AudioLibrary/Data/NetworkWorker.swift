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
