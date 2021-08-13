//
//  LocalEmployeesRepository.swift
//  Factory
//
//  Created by alok subedi on 11/08/2021.
//

import Foundation

final class LocalEmployeesRepository {
    private let store: EmployeesStore
    private let currentDate: () -> Date
    
    init(store: EmployeesStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
     typealias LoadResult = Result<[Employee], Error>

     func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieveCache { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(.some(cache)) where EmployeesCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                completion(.success(cache.employees))
                
            case .success:
                completion(.success([]))
            }
        }
    }
}

extension LocalEmployeesRepository: EmployeesCache {
    typealias SaveResult = Result<Void, Error>
    
    func save(_ employees: [Employee], completion: @escaping (SaveResult) -> Void) {
        store.deleteCache { [weak self] deletionResult in
            guard let self = self else { return }
            
            switch deletionResult {
            case .success:
                self.cache(employees, with: completion)
            
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func cache(_ employees: [Employee], with completion: @escaping (SaveResult) -> Void) {
        store.insertCache(employees, timestamp: currentDate()) { [weak self] insertionResult in
            guard self != nil else { return }
            
            completion(insertionResult)
        }
    }
}
