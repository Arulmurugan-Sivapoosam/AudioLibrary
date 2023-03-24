//
//  NetworkWorker.swift
//  AudioLibrary
//
//  Created by Dhiya on 24/03/23.
//

import Foundation

protocol AudioLibraryNetworkWorkerTraits {
  func getSongs(onFetch: @escaping (Result<[Song], Error>) -> Void)
  func downloadSong(withURL songURL: URL, onDownload: @escaping (Result<Data, Error>) -> Void)
}

final class AudioLibraryNetworkWorker: AudioLibraryNetworkWorkerTraits {
  func getSongs(onFetch: @escaping (Result<[Song], Error>) -> Void) {
    
  }
  
  func downloadSong(withURL songURL: URL, onDownload: @escaping (Result<Data, Error>) -> Void) {
    
  }
}
