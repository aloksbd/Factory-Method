//
//  EmployeesViewComposer.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

final class EmployeesViewComposer {
    static func createEmployeesViewController(setting: Settings, repository: EmployeesRepository) -> EmployeesViewController {
        let view = EmployeesViewFactory().createEmployeesView(for: setting)
        let presenter = EmployeesPresenter(repository: repository, employeesView: view)
        return EmployeesViewController(presenter: presenter, employeesView: view)
    }
}
