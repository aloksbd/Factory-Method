//
//  LocalEmployeesImageDataLoader.swift
//  Factory
//
//  Created by alok subedi on 13/08/2021.
//

import Foundation

public protocol EmployeesImageDataCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}

public protocol EmployeesImageDataStore {
    typealias RetrievalResult = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>

    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
}

public final class LocalEmployeesImageDataLoader {
    private let store: EmployeesImageDataStore
    
    public init(store: EmployeesImageDataStore) {
        self.store = store
    }
}

extension LocalEmployeesImageDataLoader: EmployeesImageDataCache {
    public typealias SaveResult = EmployeesImageDataCache.Result

    public enum SaveError: Error {
        case failed
    }

    public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, for: url) { [weak self] result in
            guard self != nil else { return }
            
            completion(result.mapError { _ in SaveError.failed })
        }
    }
}

extension LocalEmployeesImageDataLoader: EmployeeImageDataLoader {
    public typealias LoadResult = EmployeeImageDataLoader.Result

    public enum LoadError: Error {
        case failed
        case notFound
    }
    
    public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) {
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .failure:
                completion(.failure(LoadError.failed))
            case let .success(data):
                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(LoadError.notFound))
                }
            }
        }
    }
}
