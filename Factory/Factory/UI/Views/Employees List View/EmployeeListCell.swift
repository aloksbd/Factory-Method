//
//  EmployeeListCell.swift
//  Factory
//
//  Created by alok subedi on 08/08/2021.
//

import UIKit

final class EmployeeListCell: UITableViewCell {
    private(set) lazy var nameLabel = UILabel.dynamicLabel(forTextStyle: .headline)
    private(set) lazy var designationLabel: UILabel = {
        let label = UILabel.dynamicLabel()
        label.textAlignment = .right
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, designationLabel])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var salaryTitleLabel: UILabel = {
        let label = UILabel.dynamicLabel()
        label.text = "Salary: "
        return label
    }()
    private(set) lazy var salaryLabel = UILabel.dynamicLabel()
    
    private lazy var view: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addViews()
        addConstraints()
    }
    
    private func addViews() {
        [stackView, salaryTitleLabel, salaryLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        addSubview(view)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            salaryTitleLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            salaryTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            salaryTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4),
            
            salaryLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
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

extension UILabel {
    static func dynamicLabel(forTextStyle textStyle: UIFont.TextStyle = .body) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: textStyle)
        label.adjustsFontForContentSizeCategory = true
        return label
    }
}
