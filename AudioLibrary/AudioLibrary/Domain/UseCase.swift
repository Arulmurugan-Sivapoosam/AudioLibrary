//
//  UseCase.swift
//  AudioLibrary
//
//  Created by Dhiya on 24/03/23.
//

import Foundation

private let bgQueue = DispatchQueue(label: "Domain_Queue", qos: .background)

// MARK: - DomainLayer that converts Threads between View - Domain - Data layers.
protocol NetworkUseCase: AnyObject {
  associatedtype Request
  associatedtype ResponseModel

  /// executes the usecase request in a common background queue
  func execute(_ request: Request, completion: @escaping (Response<ResponseModel>) -> Void)

  /// executes the usecase request in the main queue
  func executeSync(_ request: Request, completion: @escaping (Response<ResponseModel>) -> Void)

  /// used to perform callback in the main queue
  func invoke(response: Response<ResponseModel>, completion: @escaping (Response<ResponseModel>) -> Void)
}

extension NetworkUseCase {
  func execute(_ request: Request, completion: @escaping (Response<ResponseModel>) -> Void) {
    bgQueue.async {
      self.executeSync(request) { [weak self] response in
        self?.invoke(response: response, completion: completion)
      }
    }
  }

  func invoke(response: Response<ResponseModel>, completion: @escaping (Response<ResponseModel>) -> Void) {
    switch response {
    default:
      guard Thread.isMainThread else {
        return DispatchQueue.main.async {
          completion(response)
        }
      }
      completion(response)
    }
  }
}

enum Response<ModelType> {
  case network(ModelType)
  case local(ModelType)
  case failure(Error)
  static func invoke(result: Swift.Result<ModelType, Error>) -> Response<ModelType> {
    switch result {
    case .success(let model): return .network(model)
    case .failure(let error): return .failure(error)
    }
  }
}

class UseCase {
  fileprivate let dataManager: DataManagerTraits
  init(dataManager: DataManagerTraits = AudioLibraryDataManager()) {
    self.dataManager = dataManager
  }
}

final class GetSongsList: UseCase, NetworkUseCase {
  typealias Request = Void
  typealias ResponseModel = [Song]
  
  func executeSync(_ request: Void, completion: @escaping (Response<[Song]>) -> Void) {
    dataManager.getSongs(onFetch: completion)
  }
}
