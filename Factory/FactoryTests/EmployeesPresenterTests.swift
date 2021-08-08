//
//  EmployeesPresenterTests.swift
//  FactoryTests
//
//  Created by alok subedi on 08/08/2021.
//

import XCTest
@testable import Factory

class EmployeesPresenterTests: XCTestCase {
    func test_init_doesNotLoadEmployeesFromRepository() {
        let repository = EmployeesRepositorySpy()
        let view = ViewSpy()
        _ = EmployeesPresenter(repository: repository, employeesView: view)
        
        XCTAssertEqual(repository.loadCallCount, 0)
    }
    
    func test_loadEmployees_makesCallToLoadEmployeesFromRepository() {
        let repository = EmployeesRepositorySpy()
        let view = ViewSpy()
        let sut = EmployeesPresenter(repository: repository, employeesView: view)
        
        sut.loadEmployees()
        XCTAssertEqual(repository.loadCallCount, 1)
        
        sut.loadEmployees()
        XCTAssertEqual(repository.loadCallCount, 2)
    }
    
    func test_init_doesNotSendMessagesToViews() {
        let repository = EmployeesRepositorySpy()
        let view = ViewSpy()
        _ = EmployeesPresenter(repository: repository, employeesView: view)
        
        XCTAssertEqual(view.messages, [])
    }
}

private class ViewSpy: EmployeesView {
    var messages = [Message]()
    
    enum Message: Equatable {
        case display(employees: [PresentableEmployee])
    }
}

private class EmployeesRepositorySpy: EmployeesRepository {
    var loadCallCount = 0
    
    func load(completion: @escaping ([PresentableEmployee]) -> Void) {
        loadCallCount += 1
    }
}
