//
//  EmployeesRepository.swift
//  Factory
//
//  Created by alok subedi on 11/08/2021.
//

protocol EmployeesRepository {
    typealias Result = Swift.Result<[Employee], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
