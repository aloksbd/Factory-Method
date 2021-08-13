//
//  EmployeesGridViewSnapshotTests.swift
//  FactoryUITests
//
//  Created by alok subedi on 08/08/2021.
//

import XCTest
@testable import Factory

class EmployeesGridViewSnapshotTests: XCTestCase {
    func test_withEmptyEmployees() {
        let sut = EmployeesGridView()
        let containerViewController = UIViewController()
        containerViewController.view = sut.collectionView
        
        sut.displayEmployees(emptyEmployees())

        assert(snapshot: containerViewController.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_light")
        assert(snapshot: containerViewController.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_dark")
    }
    
    func test_withEmployees() {
        let sut = EmployeesGridView()
        let containerViewController = UIViewController()
        containerViewController.view = sut.collectionView
        
        sut.displayEmployees(employees())

        assert(snapshot: containerViewController.snapshot(for: .iPhone8(style: .light)), named: "EMPLOYEES_LIST_light")
        assert(snapshot: containerViewController.snapshot(for: .iPhone8(style: .dark)), named: "EMPLOYEES_LIST_dark")
    }
    
    private func emptyEmployees() -> EmployeesViewModel {
        return EmployeesViewModel(employees: [])
    }
    
    private func employees() -> EmployeesViewModel {
        return EmployeesViewModel(employees: [
            PresentableEmployee(name: "Employee 1", designation: "designation 1", salary: "1", url: anyURL()),
            PresentableEmployee(name: "Employee 2", designation: "designation 2", salary: "2", url: anyURL()),
            PresentableEmployee(name: "Employee 3", designation: "designation 3", salary: "3", url: anyURL())
        ])
    }
}


