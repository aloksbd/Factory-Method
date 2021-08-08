//
//  EmployeesView.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

protocol EmployeesView {
    func displayEmployees(_ employees: [PresentableEmployee])
    func getView() -> UIView
}
