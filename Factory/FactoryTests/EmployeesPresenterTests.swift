//
//  EmployeesPresenterTests.swift
//  FactoryTests
//
//  Created by alok subedi on 08/08/2021.
//

import XCTest
@testable import Factory

class EmployeesPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didStartLoadingFeed_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingEmployees()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: nil),
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingFeed_displaysFeedAndStopsLoading() {
        let (sut, view) = makeSUT()
        let employees = uniqueEmployees()
        
        sut.didFinishLoadingEmployees(with: employees.employees)
        
        XCTAssertEqual(view.messages, [
            .display(employees: employees.presentableEmployeees),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingFeedWithError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT()
        let anyError = anyNSError()
        
        sut.didFinishLoadingEmployees(with: anyError)
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: anyError.localizedDescription),
            .display(isLoading: false)
        ])
    }
    
    private func makeSUT() -> (sut: EmployeesPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = EmployeesPresenter(employeesView: view, loadingView: view, errorView: view)
        
        return (sut, view)
    }
}

private class ViewSpy: EmployeesView, EmployeesLoadingView, EmployeesErrorView {
    
    func getView() -> UIView {
        return UIView()
    }
    
    var messages = [Message]()
    
    enum Message: Equatable {
        case display(employees: [PresentableEmployee])
        case display(errorMessage: String?)
        case display(isLoading: Bool)
    }
    
    func displayEmployees(_ employees: [PresentableEmployee]) {
        
    }
    func displayEmployees(_ employeesViewModel: EmployeesViewModel) {
        messages.append(.display(employees: employeesViewModel.employees))
    }
    
    func display(_ viewModel: EmployeesLoadingViewModel) {
        messages.append(.display(isLoading: viewModel.isLoading))
    }
    
    func display(_ viewModel: EmployeesErrorViewModel) {
        messages.append(.display(errorMessage: viewModel.message))
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
