//
//  EmployeesRepository.swift
//  Factory
//
//  Created by alok subedi on 11/08/2021.
//

protocol EmployeesRepository {
    func load(completion: @escaping ([PresentableEmployee]) -> Void)
}
