//
//  EmployeesViewControllerSnapshotTests.swift
//  FactoryUITests
//
//  Created by alok subedi on 08/08/2021.
//

import XCTest
@testable import Factory

class EmployeesViewControllerSnapshotTests: XCTestCase {
    func test_withEmployeesViewSpy() {
        let view = EmployeesViewSpy()
        let presenter = EmployeesPresenter(repository: RepositorySpy(), employeesView: view)
        let sut = EmployeesViewController(presenter: presenter, employeesView: view)
        sut.loadViewIfNeeded()

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EmployeesViewController_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EmployeesViewController_dark")
    }
}

private class RepositorySpy: EmployeesRepository {
    func load(completion: @escaping ([PresentableEmployee]) -> Void) {
        completion([])
    }
}

private class EmployeesViewSpy: EmployeesView {
    func displayEmployees(_ employees: [PresentableEmployee]) {}
    
    func getView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }
}
