//
//  EmployeesCache.swift
//  Factory
//
//  Created by alok subedi on 11/08/2021.
//

protocol EmployeesCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ employees: [Employee], completion: @escaping (Result) -> Void)
}
