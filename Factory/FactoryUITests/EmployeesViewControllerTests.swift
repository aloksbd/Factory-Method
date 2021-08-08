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
        let (_, presenter, _) = makeSut()
        
        XCTAssertEqual(presenter.loadCallCount, 0)
    }
    
    func test_viewDidLoad_asksToLoadEmployees() {
        let (sut, presenter, _) = makeSut()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(presenter.loadCallCount, 1)
    }
    
    func test_viewDidLoad_addsEmployeesView() {
        let (sut, _, employeesView) = makeSut()
        sut.loadViewIfNeeded()
        
        let views = sut.view.subviews
        XCTAssertEqual(views[0], employeesView.getView())
    }
    
    private func makeSut() -> (sut: EmployeesViewController, presenter: MockEmployeesPresenter, view: EmployeesViewSpy) {
        let presenter = MockEmployeesPresenter()
        let view = EmployeesViewSpy()
        let sut = EmployeesViewController(presenter: presenter, employeesView: view)
        
        return (sut, presenter, view)
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
    let view = UIView()
    func getView() -> UIView {
        view
    }
    
    func displayEmployees(_ employees: [PresentableEmployee]) {}
}

