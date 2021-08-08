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
        let (_, presenter) = makeSut()
        
        XCTAssertEqual(presenter.loadCallCount, 0)
    }
    
    func test_viewDidLoad_asksToLoadEmployees() {
        let (sut, presenter) = makeSut()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(presenter.loadCallCount, 1)
    }
    
    private func makeSut() -> (sut: EmployeesViewController, presenter: MockEmployeesPresenter) {
        let presenter = MockEmployeesPresenter()
        let sut = EmployeesViewController(presenter: presenter)
        
        return (sut, presenter)
    }
}

private class MockEmployeesPresenter: EmployeesPresenter {
    var loadCallCount = 0
    
    init() {
        super.init(repository: EmployeesRepositorySpy(), employeesView: EmployeesViewSpy())
    }
    
    override func loadEmployees() {
        loadCallCount += 1
    }
}

private class EmployeesRepositorySpy: EmployeesRepository {
    func load(completion: @escaping ([PresentableEmployee]) -> Void) {}
}

private class EmployeesViewSpy: EmployeesView {
    func displayEmployees(_ employees: [PresentableEmployee]) {}
}

