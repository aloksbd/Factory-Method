//
//  EmployeesViewControllerTests.swift
//  FactoryUITests
//
//  Created by alok subedi on 08/08/2021.
//

import XCTest
@testable import Factory

class EmployeesViewControllerIntegrationTests: XCTestCase {
    func test_init_doesNotAskToLoadEmployees() {
        let presenter = MockEmployeesPresenter()
        _ = EmployeesViewController(presenter: presenter)
        
        XCTAssertEqual(presenter.loadCallCount, 0)
    }
}

private class MockEmployeesPresenter: EmployeesPresenter {
    var loadCallCount = 0
    
    init() {
        super.init(repository: EmployeesRepositorySpy(), employeesView: EmployeesViewSpy())
    }
}

private class EmployeesRepositorySpy: EmployeesRepository {
    func load(completion: @escaping ([PresentableEmployee]) -> Void) {}
}

private class EmployeesViewSpy: EmployeesView {
    func displayEmployees(_ employees: [PresentableEmployee]) {}
}

