//
//  EmployeesGridViewTests.swift
//  FactoryUITests
//
//  Created by alok subedi on 08/08/2021.
//

import XCTest
@testable import Factory

class EmployeesGridViewTests: XCTestCase {
    func test_init_rendersNothing() {
        let sut = EmployeesGridView()
        
        XCTAssertEqual(sut.numberOfRenderedEmployees(), 0)
    }
    
    func test_displayEmployees_rendersNewEmployees() {
        let employee1 = makeEmployee(name: "Employee 1", designation: "designation 1", salary: "1")
        let employee2 = makeEmployee(name: "Employee 2", designation: "designation 2", salary: "2")
        let employee3 = makeEmployee(name: "Employee 3", designation: "designation 3", salary: "3")
        let employees = [employee1, employee2, employee3]
        
        let sut = EmployeesGridView()
        XCTAssertEqual(sut.numberOfRenderedEmployees(), 0)
        
        sut.displayEmployees(employees)
        
        XCTAssertEqual(sut.numberOfRenderedEmployees(), employees.count)
        
        employees.enumerated().forEach { index, employee in
            guard let cell = sut.employeeView(at: index) as? EmployeeGridCell else {
                return XCTFail("Expected EmployeeListCell")
            }
            XCTAssertEqual(cell.name, employee.name)
            XCTAssertEqual(cell.designation, employee.designation)
            XCTAssertEqual(cell.salary, employee.salary)
        }
    }
    
    private func makeEmployee(name: String, designation: String, salary: String) -> PresentableEmployee {
        return PresentableEmployee(name: name, designation: designation, salary: salary)
    }

}

private extension EmployeesGridView {
    func employeeView(at row: Int) -> UICollectionViewCell? {
        guard numberOfRenderedEmployees() > row else {
            return nil
        }
        let ds = collectionView.dataSource
        let index = IndexPath(item: row, section: EmployeeListSection)
        return ds?.collectionView(collectionView, cellForItemAt: index)
    }
    
    func numberOfRenderedEmployees() -> Int {
        collectionView.numberOfItems(inSection: EmployeeListSection)
    }
    
    private var EmployeeListSection: Int { 0 }
}

private extension EmployeeGridCell {
    var name: String? { nameLabel.text }
    var designation: String? { designationLabel.text }
    var salary: String? { salaryLabel.text }
}
