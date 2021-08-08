//
//  EmployeesListViewSnapshotTests.swift
//  FactoryUITests
//
//  Created by alok subedi on 08/08/2021.
//

import XCTest
@testable import Factory

class EmployeesListViewSnapshotTests: XCTestCase {
    func test_withEmptyEmployees() {
        let sut = EmployeesListView()
        let containerViewController = UIViewController()
        containerViewController.view = sut.tableView
        
        sut.displayEmployees(emptyEmployees())

        assert(snapshot: containerViewController.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_light")
        assert(snapshot: containerViewController.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_dark")
    }
    
    func test_withEmployees() {
        let sut = EmployeesListView()
        let containerViewController = UIViewController()
        containerViewController.view = sut.tableView
        
        sut.displayEmployees(employees())

        assert(snapshot: containerViewController.snapshot(for: .iPhone8(style: .light)), named: "EMPLOYEES_LIST_light")
        assert(snapshot: containerViewController.snapshot(for: .iPhone8(style: .dark)), named: "EMPLOYEES_LIST_dark")
    }
    
    private func emptyEmployees() -> [PresentableEmployee] {
        return []
    }
    
    private func employees() -> [PresentableEmployee] {
        return [
            PresentableEmployee(name: "Employee 1", designation: "designation 1", salary: "1"),
            PresentableEmployee(name: "Employee 2", designation: "designation 2", salary: "2"),
            PresentableEmployee(name: "Employee 3", designation: "designation 3", salary: "3")
        ]
    }
}


