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
        repository.load {[weak self] result in
            guard let self = self else { return }
            if let employees = try? result.get() {
                self.employeesView.displayEmployees(employees.toPresentableModels())
            }
        }
    }
}

private extension Array where Element == Employee {
    func toPresentableModels() -> [PresentableEmployee] {
        return map { PresentableEmployee(name: $0.name, designation: $0.designation, salary: "\($0.salary)")}
    }
}
