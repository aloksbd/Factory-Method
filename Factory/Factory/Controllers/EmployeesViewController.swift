//
//  EmployeesViewController.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

final class EmployeesViewController: UIViewController {
    private var presenter: EmployeesPresenter!
    private var employeesView: EmployeesView!
    
    convenience init(presenter: EmployeesPresenter, employeesView: EmployeesView) {
        self.init()
        self.presenter = presenter
        self.employeesView = employeesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.loadEmployees()
        view.addSubview(employeesView.getView())
    }

}

