//
//  EmployeesViewFactoryTests.swift
//  FactoryUITests
//
//  Created by alok subedi on 08/08/2021.
//

import XCTest
@testable import Factory

class EmployeesViewFactoryTests: XCTestCase {
    func test_createEployeesView_returnsEmployeesViewBasedOnSettings() {
        let sut = EmployeesViewFactory()
        
        let view1 = sut.createEmployeesView(for: .list)
        guard let _ = view1 as? EmployeesListView else {
            return XCTFail("Should create EmployeesListView")
        }
        
        let view2 = sut.createEmployeesView(for: .grid)
        guard let _ = view2 as? EmployeesGridView else {
            return XCTFail("Should create EmployeesGridView")
        }
    }
}
