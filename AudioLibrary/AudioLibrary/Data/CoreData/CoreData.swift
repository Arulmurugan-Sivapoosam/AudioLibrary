//
//  CoreData.swift
//  AudioLibrary
//
//  Created by Arul on 25/03/23.
//

import Foundation
import CoreData

// MARK: - Reusable Coredata layer.
protocol CoreDataStorable {
  associatedtype CoreDataType: NSManagedObject
  var context: NSManagedObjectContext {get}
}

extension CoreDataStorable {
  var context: NSManagedObjectContext { CoreDataWorker.shared.currentContext }
  typealias ObjectResult = Result<CoreDataType, CoreDataError>
  typealias ObjectsResult = Result<[CoreDataType], CoreDataError>
  
  private var entityName: String { CoreDataType.entity().name ?? "\(CoreDataType.self)"}
  
  func insertNewEntity() -> CoreDataType? {
    NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? CoreDataType
  }
  
  func objects(with predicate: NSPredicate?, sorterDescriptor: [NSSortDescriptor] = .empty, fetchLimit: Int?, onFetch: @escaping (ObjectsResult) -> Void) {
    let fetchRequest = NSFetchRequest<CoreDataType>(entityName: entityName)
    fetchRequest.sortDescriptors = sorterDescriptor
    fetchRequest.predicate = predicate
    if let fetchLimit = fetchLimit {
      fetchRequest.fetchLimit = fetchLimit
    }
    return CoreDataWorker.shared.mainContext.performFetch(request: fetchRequest, onfetch: onFetch)
  }
  
  func object(withPredicate predicate: NSPredicate? = nil, sorterDescriptor: [NSSortDescriptor] = .empty, onFetch: @escaping (ObjectResult) -> Void) {
    objects(with: predicate, sorterDescriptor: sorterDescriptor, fetchLimit: 1, onFetch: { result in
      switch result {
      case .success(let responseArray):
        guard let firstElement = responseArray.first else {return onFetch(.failure(.nothingFound))}
        onFetch(.success(firstElement))
      case .failure(let error):
        onFetch(.failure(error))
      }
    })
  }
  
  func saveContext() {
    context.saveChanges()
  }
  
  func dataModels<DataModelType>(with predicate: NSPredicate? = nil, sorterDescriptor: [NSSortDescriptor] = .empty, fetchLimit: Int? = nil, transform: @escaping(CoreDataType) -> DataModelType, onFetch: @escaping (Result<[DataModelType], CoreDataError>) -> Void) {
    objects(with: predicate, sorterDescriptor: sorterDescriptor, fetchLimit: fetchLimit, onFetch: { result in
      switch result {
      case .success(let responseArray):
        onFetch(.success(responseArray.map {transform($0)}))
      case .failure(let error):
        onFetch(.failure(error))
      }
    })
  }
}


// MARK: - CoreData worker
final class CoreDataWorker {
  static let shared: CoreDataWorker = .init()
  private init() {}
  
  func loadPersistantContainer() {
    _ = persitantCoordinator
  }
  
  lazy var mainContext: NSManagedObjectContext = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persitantCoordinator
    managedObjectContext.shouldDeleteInaccessibleFaults = true
    managedObjectContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    return managedObjectContext
  }()
  
  lazy var privateContextWithParent: NSManagedObjectContext = {
    return mainContext.privateChildContext
  }()
  
  var currentContext: NSManagedObjectContext {
    Thread.isMainThread ? mainContext : privateContextWithParent
  }
  
  private lazy var persitantCoordinator: NSPersistentStoreCoordinator = {
    let coordinator: NSPersistentStoreCoordinator = .init(managedObjectModel: managedObjectModel)
    guard var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {fatalError("directory should not be nil")}
    documentDirectory.appendPathComponent(.CoreData.tableName)
    documentDirectory.appendPathExtension(.CoreData.tableType)
    do {
      print("SQlite URL", documentDirectory.absoluteString)
      try coordinator.addPersistentStore(
        ofType: NSSQLiteStoreType,
        configurationName: nil,
        at: documentDirectory,
        options: [
          NSMigratePersistentStoresAutomaticallyOption: true,
          NSInferMappingModelAutomaticallyOption: true
        ])
    } catch let error {
      print("Error when adding persistant container: \(error.localizedDescription)")
    }
    return coordinator
  }()
  
  private lazy var managedObjectModel: NSManagedObjectModel = {
    guard let dbURL = Bundle.main.url(forResource: .CoreData.tableName, withExtension: .CoreData.tableExtn),
          let managedObjectModel = NSManagedObjectModel(contentsOf: dbURL) else { fatalError("DB URL or managedObjectModel should not be nil") }
    return managedObjectModel
  }()
}

extension NSManagedObjectContext {
  public var privateChildContext: NSManagedObjectContext {
    let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    privateContext.automaticallyMergesChangesFromParent = true
    privateContext.parent = self
    privateContext.shouldDeleteInaccessibleFaults = true
    privateContext.mergePolicy =  NSMergePolicy.mergeByPropertyObjectTrump
    return privateContext
  }
  
  @discardableResult
  public func saveChanges(inContextName context: String = "Context") -> Bool {
    var isSuccess = true
    
    self.performAndWait {
      guard let persistentStores = self.persistentStoreCoordinator?.persistentStores.count, persistentStores > 0  else {
        print("❌ Error: Failed to find Persistent store to save", context)
        isSuccess = false
        return
      }
      do {
        try self.save()
      } catch let error {
        print("Error: Failed to save \(context), Error: \(error.localizedDescription)")
        isSuccess = false
      }
    }
    return isSuccess
  }
  
  func performFetch<ManagedObject: NSFetchRequestResult>(request: NSFetchRequest<ManagedObject>, onfetch: @escaping (Result<[ManagedObject], CoreDataError>) -> Void) {
    self.perform {
      do {
        let respose = try self.fetch(request)
        onfetch(respose.isEmpty ? .failure(.nothingFound) : .success(respose))
      } catch {
        onfetch(.failure(.nothingFound))
      }
    }
  }
}

enum CoreDataError: Error {
  case nothingFound
  case custom(Error)
}
