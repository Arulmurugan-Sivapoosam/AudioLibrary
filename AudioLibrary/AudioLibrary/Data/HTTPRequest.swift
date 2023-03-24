//
//  HTTPRequest.swift
//  AudioLibrary
//
//  Created by Dhiya on 24/03/23.
//

import Foundation

enum NetworkError: Error{
  case URLValidationFailed
  case coruptedData
  case serverError(Error)
  case decodingFailed(Error)
}

class NetworkManager {
  func getResponse<Response: Decodable>(request: Request, onFetch: @escaping (Result<Response, NetworkError>) -> Void) {
    guard let request = request.urlRequest else { return onFetch(.failure(NetworkError.URLValidationFailed)) }
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error {
        onFetch(.failure(.serverError(error)))
      } else if let data {
        do {
          try onFetch(.success(JSONDecoder().decode(Response.self, from: data)))
        } catch let error {
          onFetch(.failure(.decodingFailed(error)))
        }
      } else {
        onFetch(.failure(.coruptedData))
      }
    }.resume()
  }
}


extension NetworkManager {
  enum Request {
    case getSongs
    case downloadSong(String)
    
    fileprivate var urlRequest: URLRequest? {
      guard let url = URL(string: urlStr) else {return nil}
      return .init(url: url)
    }
    
    private var urlStr: String {
      switch self {
      case .getSongs: return "https://gist.githubusercontent.com/Lenhador/a0cf9ef19cd816332435316a2369bc00/raw/a1338834fc60f7513402a569af09ffa302a26b63/Songs.json"
      case .downloadSong(let songLocation): return songLocation
      }
    }
  }
}
