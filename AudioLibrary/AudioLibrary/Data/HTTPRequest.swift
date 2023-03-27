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
    
    fileprivate var urlRequest: URLRequest? {
      guard let url = URL(string: urlStr) else {return nil}
      return .init(url: url)
    }
    
    private var urlStr: String {
      switch self {
      case .getSongs: return "https://gist.githubusercontent.com/Lenhador/a0cf9ef19cd816332435316a2369bc00/raw/a1338834fc60f7513402a569af09ffa302a26b63/Songs.json"
      }
    }
  }
}

// MARK: - Download manager downloads the data and notifies the fraction at real time.
class NetworkDownloadManager: NSObject, URLSessionDownloadDelegate {  
  private weak var delegate: DownloadableDelegate?
  
  init(delegate: DownloadableDelegate) {
    self.delegate = delegate
  }
  
  func downloadData(from urlStr: String) {
    guard let url = URL(string: urlStr) else {return}
    let downloadTask = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
      .downloadTask(with: .init(url: url))
    downloadTask.resume()
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    let reader = try? FileHandle(forReadingFrom: location)
    if let data = reader?.readDataToEndOfFile() {
      delegate?.didCompleteDownloading(data: data)
    }
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    let fraction = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    delegate?.didDownload(fraction: fraction)
  }
}
