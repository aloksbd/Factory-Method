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
        let sut = EmployeesViewController(loader: LoaderSpy(), employeesView: view)
        sut.loadViewIfNeeded()

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EmployeesViewController_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EmployeesViewController_dark")
    }
}

private class RepositorySpy: EmployeesRepository {
    func load(completion: @escaping (EmployeesRepository.Result) -> Void) { }
}

private class EmployeesViewSpy: EmployeesLayoutView {
    func getView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }
}

private class LoaderSpy: EmployeesLoader {
    func load() {}
}
