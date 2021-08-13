//
//  EmployeesViewController.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

protocol EmployeesLoader {
    func load()
}

final class EmployeesViewController: UIViewController, EmployeesLoadingView, EmployeesErrorView {
    
    private var employeesView: UIView!
    private var loader: EmployeesLoader!
    
    convenience init(loader: EmployeesLoader, employeesView: EmployeesLayoutView) {
        self.init()
        self.loader = loader
        self.employeesView = employeesView.getView()
        self.employeesView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loader.load()
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
    
    func display(_ viewModel: EmployeesLoadingViewModel) {
        // TODO: loading view
    }
    
    func display(_ viewModel: EmployeesErrorViewModel) {
        // TODO: error View
    }
}

