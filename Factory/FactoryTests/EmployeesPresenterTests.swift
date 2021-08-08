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
        _ = EmployeesPresenter(repository: repository)
        
        XCTAssertEqual(repository.loadCallCount, 0)
    }
}

private class EmployeesRepositorySpy: EmployeesRepository {
    var loadCallCount = 0
    
    func load(completion: @escaping ([PresentableEmployee]) -> Void) {
        loadCallCount += 1
    }
}
