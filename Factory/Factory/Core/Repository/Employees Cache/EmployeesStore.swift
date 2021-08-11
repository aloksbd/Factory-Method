//
//  EmployeesStore.swift
//  Factory
//
//  Created by alok subedi on 11/08/2021.
//

import Foundation

typealias CachedEmployees = (employees: [Employee], timestamp: Date)

protocol EmployeesStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<CachedEmployees?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    func deleteCache(completion: @escaping DeletionCompletion)
    func insertCache(_ employees: [Employee], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieveCache(completion: @escaping RetrievalCompletion)
}
