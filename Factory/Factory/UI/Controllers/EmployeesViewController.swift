//
//  EmployeesViewController.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

final class EmployeesViewController: UIViewController {
    private var presenter: EmployeesPresenter!
    private var employeesView: UIView!
    
    convenience init(presenter: EmployeesPresenter, employeesView: EmployeesView) {
        self.init()
        self.presenter = presenter
        self.employeesView = employeesView.getView()
        self.employeesView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.loadEmployees()
        view.addSubview(employeesView)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            employeesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            employeesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            employeesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            employeesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

}

