//
//  EmployeesPresenter.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

class EmployeesPresenter {
    private let repository: EmployeesRepository
    private let employeesView: EmployeesView
    
    init(repository: EmployeesRepository, employeesView: EmployeesView) {
        self.repository = repository
        self.employeesView = employeesView
    }
    
    func loadEmployees() {
        repository.load { employees in
            self.employeesView.displayEmployees(employees)
        }
    }
}
