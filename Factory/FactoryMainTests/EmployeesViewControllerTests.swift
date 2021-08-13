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
        let (_, repository) = makeSut()
        
        XCTAssertEqual(repository.loadCallCount, 0)
    }
    
    func test_viewDidLoad_asksToLoadEmployees() {
        let (sut, repository) = makeSut()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(repository.loadCallCount, 1)
    }
    
    func test_viewDidLoad_addsEmployeesView() {
        let (sut, _) = makeSut()
        sut.loadViewIfNeeded()
        
        let views = sut.view.subviews
        guard let _ = views[0] as? UITableView else {
            return XCTFail("Should create EmployeesListView")
        }
    }
    
    private func makeSut() -> (sut: EmployeesViewController, repository: EmployeesRepositorySpy) {
        let repository = EmployeesRepositorySpy()
        let sut = EmployeesViewComposer.createEmployeesViewController(setting: .list, repository: repository, imageLoader: EmployeeImageDataLoaderSpy())
        
        return (sut, repository)
    }
}

private class EmployeeImageDataLoaderSpy: EmployeeImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (EmployeeImageDataLoader.Result) -> Void) { }
}

private class EmployeesRepositorySpy: EmployeesRepository {
    var loadCallCount = 0
    func load(completion: @escaping (EmployeesRepository.Result) -> Void) {
        loadCallCount += 1
    }
}

