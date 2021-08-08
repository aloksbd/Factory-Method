//
//  EmployeesViewFactory.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

class EmployeesViewFactory {
    func createEmployeesView(for setting: Settings) -> EmployeesView {
        switch setting {
        case .list:
            return EmployeesListView()
        case .grid:
            return EmployeesGridView()
        }
    }
}

