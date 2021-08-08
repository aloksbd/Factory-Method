//
//  EmployeesListView.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

final class EmployeesListView: NSObject, EmployeesView {
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var employees = [PresentableEmployee]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    func displayEmployees(_ employees: [PresentableEmployee]) {
        self.employees = employees
    }
    
    func getView() -> UIView {
        return tableView
    }
}

extension EmployeesListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EmployeeListCell()
        cell.nameLabel.text = employees[indexPath.row].name
        cell.designationLabel.text = employees[indexPath.row].designation
        cell.salaryLabel.text = employees[indexPath.row].salary
        return cell
    }
}
