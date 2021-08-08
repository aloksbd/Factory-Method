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
        let employee1 = makeEmployee(name: "Employee 1", designation: "designation 1", salary: "1")
        let employee2 = makeEmployee(name: "Employee 2", designation: "designation 2", salary: "2")
        
        let sut = EmployeesListView()
        sut.displayEmployees([employee1, employee2])
        
        XCTAssertEqual(sut.numberOfRenderedEmployees(), 2)
    }
    
    private func makeEmployee(name: String, designation: String, salary: String) -> PresentableEmployee {
        return PresentableEmployee(name: name, designation: designation, salary: salary)
    }

}

private extension EmployeesListView {
    func numberOfRenderedEmployees() -> Int {
        tableView.numberOfRows(inSection: EmployeeListSection)
    }
    
    private var EmployeeListSection: Int { 0 }
}
