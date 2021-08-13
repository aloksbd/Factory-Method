//
//  EmployeesListView.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

extension UITableViewCell {
    static var cellId: String {
        return description()
    }
}

final class EmployeesListView: NSObject, EmployeesLayoutView {
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(EmployeeListCell.self, forCellReuseIdentifier: EmployeeListCell.cellId)
        return tableView
    }()
    
    private var cellControllers = [EmployeesListCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    func display(_ cellControllers: [EmployeesListCellController]) {
        self.cellControllers = cellControllers
    }
    
    func getView() -> UIView {
        return tableView
    }
}

extension EmployeesListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellControllers[indexPath.row].view(in: tableView)
    }
}



protocol ImageLoader {
    func loadImage()
}

final class EmployeesListCellController: EmployeeImageView {
    private let loader: ImageLoader
    private var cell: EmployeeListCell?
    private var employee: PresentableEmployee
    
    public init(loader: ImageLoader, employee: PresentableEmployee) {
        self.loader = loader
        loader.loadImage()
        self.employee = employee
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: EmployeeListCell.cellId) as? EmployeeListCell
        cell?.nameLabel.text = employee.name
        cell?.designationLabel.text = employee.designation
        cell?.salaryLabel.text = employee.salary
        loader.loadImage()
        return cell!
    }
    
    func display(_ model: EmployeeImageViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.cell?.employeeImageView.image = model.image
            self?.cell?.setNeedsLayout()
        }
    }
}

