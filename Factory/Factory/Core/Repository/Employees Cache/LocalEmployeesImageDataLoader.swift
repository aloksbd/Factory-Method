//
//  LocalEmployeesImageDataLoader.swift
//  Factory
//
//  Created by alok subedi on 13/08/2021.
//

import Foundation

protocol EmployeesImageDataCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}

protocol EmployeesImageDataStore {
    typealias RetrievalResult = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>

    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
}

final class LocalEmployeesImageDataLoader {
    private let store: EmployeesImageDataStore
    
    init(store: EmployeesImageDataStore) {
        self.store = store
    }
}

extension LocalEmployeesImageDataLoader: EmployeesImageDataCache {
    typealias SaveResult = EmployeesImageDataCache.Result

    enum SaveError: Error {
        case failed
    }

    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, for: url) { [weak self] result in
            guard self != nil else { return }
            
            completion(result.mapError { _ in SaveError.failed })
        }
    }
}

extension LocalEmployeesImageDataLoader: EmployeeImageDataLoader {
    typealias LoadResult = EmployeeImageDataLoader.Result

    enum LoadError: Error {
        case failed
        case notFound
    }
    
    func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) {
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
