//
//  EmployeesGridView.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

final class EmployeesGridView: NSObject {
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        return collectionView
    }()
    
    private var employees = [PresentableEmployee]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func displayEmployees(_ employees: [PresentableEmployee]) {
        self.employees = employees
    }
}

extension EmployeesGridView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        employees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = EmployeeGridCell()
        cell.nameLabel.text = employees[indexPath.row].name
        cell.designationLabel.text = employees[indexPath.row].designation
        cell.salaryLabel.text = employees[indexPath.row].salary
        return cell
    }
}
