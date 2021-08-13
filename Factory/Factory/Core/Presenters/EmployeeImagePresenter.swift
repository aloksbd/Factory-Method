//
//  EmployeeImagePresenter.swift
//  Factory
//
//  Created by alok subedi on 13/08/2021.
//

import UIKit

struct EmployeeImageViewModel {
    let image: UIImage?
}

protocol EmployeeImageView {
    func display(_ model: EmployeeImageViewModel)
}

final class EmployeeImagePresenter {
    private let view: EmployeeImageView
    
    init(view: EmployeeImageView) {
        self.view = view
    }
    
    func didStartLoadingImageData() {
        view.display(EmployeeImageViewModel(image: nil))
    }
    
    func didFinishLoadingImageData(with data: Data) {
        let image = UIImage(data: data)
        view.display(EmployeeImageViewModel(image: image))
    }
    
    func didFinishLoadingImageData(with error: Error) {
        view.display(EmployeeImageViewModel(image: nil))
    }
}
