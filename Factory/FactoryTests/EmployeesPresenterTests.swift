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
        let(_, repository, _) = makeSut()
        
        XCTAssertEqual(repository.loadCallCount, 0)
    }
    
    func test_loadEmployees_makesCallToLoadEmployeesFromRepository() {
        let(sut, repository, _) = makeSut()
        
        sut.loadEmployees()
        XCTAssertEqual(repository.loadCallCount, 1)
        
        sut.loadEmployees()
        XCTAssertEqual(repository.loadCallCount, 2)
    }
    
    func test_init_doesNotSendMessagesToViews() {
        let(_, _, view) = makeSut()
        
        XCTAssertEqual(view.messages, [])
    }
    
    func test_loadEmployees_displaysEmployees() {
        let(sut, repository, view) = makeSut()
        
        let (employees, presentableEmployees) = uniqueEmployees()
        
        sut.loadEmployees()
        repository.complete(with: employees)
        
        XCTAssertEqual(view.messages, [.display(employees: presentableEmployees)])
    }
    
    private func makeSut() -> (sut: EmployeesPresenter, repository: EmployeesRepositorySpy, view: ViewSpy) {
        let repository = EmployeesRepositorySpy()
        let view = ViewSpy()
        let sut = EmployeesPresenter(repository: repository, employeesView: view)
        
        return (sut, repository, view)
    }
}

private class ViewSpy: EmployeesView {
    func getView() -> UIView {
        return UIView()
    }
    
    var messages = [Message]()
    
    enum Message: Equatable {
        case display(employees: [PresentableEmployee])
    }
    
    func displayEmployees(_ employees: [PresentableEmployee]) {
        messages.append(.display(employees: employees))
    }
}

private class EmployeesRepositorySpy: EmployeesRepository {
    var loadCallCount: Int {
        completions.count
    }
    private var completions = [(EmployeesRepository.Result) -> Void]()
    
    func load(completion: @escaping (EmployeesRepository.Result) -> Void) {
        completions.append(completion)
    }
    
    func complete(with employees: [Employee], at index: Int = 0) {
        completions[index](.success(employees))
    }
}
