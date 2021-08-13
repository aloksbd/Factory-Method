//
//  EmployeeImagePresenterTests.swift
//  FactoryTests
//
//  Created by alok subedi on 13/08/2021.
//

import XCTest
@testable import Factory

class EmployeeImagePresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingImageData_displaysLoadingImage() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingImageData()
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertNil(message?.image)
    }
    
    func test_didFinishLoadingImageData_displaysRetryOnFailedImageTransformation() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoadingImageData(with: Data())
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertNil(message?.image)
    }
    
    func test_didFinishLoadingImageData_displaysImageOnSuccessfulTransformation() {
        let image = makeImage(withColor: .red)
        let data = image.jpegData(compressionQuality: 1)!
        let (sut, view) = makeSUT()
        
        sut.didFinishLoadingImageData(with: data)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertNotNil(message?.image)
    }
    
    func test_didFinishLoadingImageDataWithError_displaysRetry() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoadingImageData(with: anyNSError())
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertNil(message?.image)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: EmployeeImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = EmployeeImagePresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: EmployeeImageView {
        private(set) var messages = [EmployeeImageViewModel]()
        
        func display(_ model: EmployeeImageViewModel) {
            messages.append(model)
        }
    }

    func makeImage(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}



