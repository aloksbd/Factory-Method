//
//  EmployeeGridCell.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

final class EmployeeGridCell: UICollectionViewCell {
    private(set) lazy var nameLabel = UILabel()
    private(set) lazy var designationLabel = UILabel()
    private lazy var salaryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Salary: "
        return label
    }()
    private(set) lazy var salaryLabel = UILabel()
    
    private lazy var view: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        addConstraints()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func addViews() {
        [nameLabel, designationLabel, salaryTitleLabel, salaryLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        addSubview(view)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            
            designationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            designationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            salaryTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            salaryTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            salaryTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4),
            
            salaryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            salaryLabel.leadingAnchor.constraint(equalTo: salaryTitleLabel.trailingAnchor),
            
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
