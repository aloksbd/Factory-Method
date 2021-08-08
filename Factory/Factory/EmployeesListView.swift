//
//  EmployeesListView.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

final class EmployeesListView: NSObject {
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        return tableView
    }()
    
    private var employees = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    func displayEmployees(_ employees: [String]) {
        self.employees = employees
    }
}

extension EmployeesListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = employees[indexPath.row]
        return cell
    }
}
