//
//  CoreDataEmployeeImageDataStoreTests.swift
//  FactoryTests
//
//  Created by alok subedi on 13/08/2021.
//

import XCTest
@testable import Factory

class CoreDataEmployeeImageDataStoreTests: XCTestCase {
    
    func test_retrieveImageData_deliversNotFoundWhenEmpty() {
        let sut = makeSUT()
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: anyURL())
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() {
        let sut = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let nonMatchingURL = URL(string: "http://another-url.com")!
        
        insert(anyData(), for: url, into: sut)
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: nonMatchingURL)
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() {
        let sut = makeSUT()
        let storedData = anyData()
        let matchingURL = URL(string: "http://a-url.com")!
        
        insert(storedData, for: matchingURL, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(storedData), for: matchingURL)
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() {
        let sut = makeSUT()
        let firstStoredData = Data("first".utf8)
        let lastStoredData = Data("last".utf8)
        let url = URL(string: "http://a-url.com")!
        
        insert(firstStoredData, for: url, into: sut)
        insert(lastStoredData, for: url, into: sut)

        expect(sut, toCompleteRetrievalWith: found(lastStoredData), for: url)
    }

    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataEmployeesStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataEmployeesStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func notFound() -> EmployeesImageDataStore.RetrievalResult {
        return .success(.none)
    }
    
    private func found(_ data: Data) -> EmployeesImageDataStore.RetrievalResult {
        return .success(data)
    }
    
    private func localImage(url: URL) -> Employee {
        return Employee(id: UUID(), name: "name", designation: "designation", salary: 1, url: url)
    }

    private func expect(_ sut: CoreDataEmployeesStore, toCompleteRetrievalWith expectedResult: EmployeesImageDataStore.RetrievalResult, for url: URL,  file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.retrieve(dataForURL: url) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success( receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    private func insert(_ data: Data, for url: URL, into sut: CoreDataEmployeesStore, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache insertion")
        let image = localImage(url: url)
        sut.insertCache([image], timestamp: Date()) { result in
            switch result {
            case let .failure(error):
                XCTFail("Failed to save \(image) with error \(error)", file: file, line: line)
                exp.fulfill()

            case .success:
                sut.insert(data, for: url) { result in
                    if case let Result.failure(error) = result {
                        XCTFail("Failed to insert \(data) with error \(error)", file: file, line: line)
                    }
                    exp.fulfill()
                }
            }
        }
        wait(for: [exp], timeout: 1.0)
    }

}
