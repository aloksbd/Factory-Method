//
//  EmployeesViewController.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

final class EmployeesViewController: UIViewController {
    private var presenter: EmployeesPresenter!
    
    convenience init(presenter: EmployeesPresenter) {
        self.init()
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.loadEmployees()
    }

}

