//
//  EmployeesListView.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit


final class EmployeesListView: NSObject, EmployeesLayoutView {
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
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
        return cellControllers[indexPath.row].view()
    }
}



protocol ImageLoader {
    func loadImage()
}

final class EmployeesListCellController: EmployeeImageView {
    private let loader: ImageLoader
    private var cell: EmployeeListCell
    
    public init(loader: ImageLoader, employee: PresentableEmployee) {
        self.loader = loader
        self.cell = EmployeeListCell()
        cell.nameLabel.text = employee.name
        cell.designationLabel.text = employee.designation
        cell.salaryLabel.text = employee.salary
        loader.loadImage()
    }
    
    func view() -> UITableViewCell {
        return cell
    }
    
    func display(_ model: EmployeeImageViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.cell.employeeImageView.image = model.image
        }
    }
}

