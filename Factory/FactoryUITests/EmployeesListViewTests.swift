//
//  EmployeesListViewTests.swift
//  FactoryUITests
//
//  Created by alok subedi on 08/08/2021.
//

import XCTest
@testable import Factory

class EmployeesListViewTests: XCTestCase {
    func test_init_rendersNothing() {
        let sut = EmployeesListView()
        
        XCTAssertEqual(sut.numberOfRenderedEmployees(), 0)
    }
    
    func test_displayEmployees_rendersNewEmployees() {
        let employees = ["employee1", "employee 2"]
        let sut = EmployeesListView()
        sut.displayEmployees(employees)
        
        XCTAssertEqual(sut.numberOfRenderedEmployees(), 2)
    }
}

private extension EmployeesListView {
    func numberOfRenderedEmployees() -> Int {
        tableView.numberOfRows(inSection: EmployeeListSection)
    }
    
    private var EmployeeListSection: Int { 0 }
}
