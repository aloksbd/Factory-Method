//
//  EmployeesPresenter.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

protocol EmployeesRepository {
    func load(completion: @escaping ([PresentableEmployee]) -> Void)
}

class EmployeesPresenter {
    private let repository: EmployeesRepository
    
    init(repository: EmployeesRepository) {
        self.repository = repository
    }
}
