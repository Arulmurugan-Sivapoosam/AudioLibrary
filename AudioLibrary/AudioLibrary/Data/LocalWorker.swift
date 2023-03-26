//
//  LocalService.swift
//  AudioLibrary
//
//  Created by Dhiya on 24/03/23.
//

import Foundation

protocol AudioLibraryLocalWorkerTraits {
  func getSongs(onFetch: @escaping (Result<[Song], CoreDataError>) -> Void)
}

final class AudioLibraryLocalWorker: AudioLibraryLocalWorkerTraits {
  func getSongs(onFetch: @escaping (Result<[Song], CoreDataError>) -> Void) {
    SongsCoreDataHelper().getSongs(onFetch: onFetch)
  }  
}
