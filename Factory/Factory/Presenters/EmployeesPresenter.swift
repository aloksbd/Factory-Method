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
    private let employeesView: EmployeesView
    
    init(repository: EmployeesRepository, employeesView: EmployeesView) {
        self.repository = repository
        self.employeesView = employeesView
    }
    
    func loadEmployees() {
        repository.load { _ in }
    }
}
