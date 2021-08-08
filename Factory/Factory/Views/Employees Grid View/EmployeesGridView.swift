//
//  EmployeesGridView.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

final class EmployeesGridView: NSObject {
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 160, height: 85)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 8, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(EmployeeGridCell.self, forCellWithReuseIdentifier: "EmployeeGrid")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmployeeGrid", for: indexPath) as! EmployeeGridCell
        cell.nameLabel.text = employees[indexPath.row].name
        cell.designationLabel.text = employees[indexPath.row].designation
        cell.salaryLabel.text = employees[indexPath.row].salary
        return cell
    }
}
