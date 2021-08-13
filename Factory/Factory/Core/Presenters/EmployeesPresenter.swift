//
//  EmployeesPresenter.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

struct EmployeesViewModel {
    let employees: [PresentableEmployee]
}

struct EmployeesLoadingViewModel {
    let isLoading: Bool
}

protocol EmployeesLoadingView {
    func display(_ viewModel: EmployeesLoadingViewModel)
}

struct EmployeesErrorViewModel {
    let message: String?
}

protocol EmployeesErrorView {
    func display(_ viewModel: EmployeesErrorViewModel)
}

class EmployeesPresenter {
    private let employeesView: EmployeesView
    private let loadingView: EmployeesLoadingView
    private let errorView: EmployeesErrorView
    
    init(employeesView: EmployeesView, loadingView: EmployeesLoadingView, errorView: EmployeesErrorView) {
        self.employeesView = employeesView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    func didStartLoadingEmployees() {
        errorView.display(EmployeesErrorViewModel(message: nil))
        loadingView.display(EmployeesLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingEmployees(with employees: [Employee]) {
        employeesView.displayEmployees(EmployeesViewModel(employees: employees.toPresentableModels()))
        loadingView.display(EmployeesLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingEmployees(with error: Error) {
        errorView.display(EmployeesErrorViewModel(message: error.localizedDescription))
        loadingView.display(EmployeesLoadingViewModel(isLoading: false))
    }
}
private extension Array where Element == Employee {
    func toPresentableModels() -> [PresentableEmployee] {
        return map { PresentableEmployee(name: $0.name, designation: $0.designation, salary: "\($0.salary)", url: $0.url)}
    }
}
