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
    
    private func emptyEmployees() -> [PresentableEmployee] {
        return []
    }
}


