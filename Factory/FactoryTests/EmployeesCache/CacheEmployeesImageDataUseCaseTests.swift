//
//  CacheEmployeesImageDataUseCaseTests.swift
//  FactoryTests
//
//  Created by alok subedi on 13/08/2021.
//

import XCTest
@testable import Factory

class CacheEmployeesImageDataUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_saveImageDataForURL_requestsImageDataInsertionForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        let data = anyData()
        
        sut.save(data, for: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.insert(data: data, for: url)])
    }
    
    func test_saveImageDataFromURL_failsOnStoreInsertionError() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: failed(), when: {
            let insertionError = anyNSError()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_saveImageDataFromURL_succeedsOnSuccessfulStoreInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success(()), when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_saveImageDataFromURL_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = EmployeesImageDataStoreSpy()
        var sut: LocalEmployeesImageDataLoader? = LocalEmployeesImageDataLoader(store: store)
        
        var received = [LocalEmployeesImageDataLoader.SaveResult]()
        sut?.save(anyData(), for: anyURL()) { received.append($0) }
        
        sut = nil
        store.completeInsertionSuccessfully()

        XCTAssertTrue(received.isEmpty, "Expected no received results after instance has been deallocated")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalEmployeesImageDataLoader, store: EmployeesImageDataStoreSpy) {
        let store = EmployeesImageDataStoreSpy()
        let sut = LocalEmployeesImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func failed() -> LocalEmployeesImageDataLoader.SaveResult {
        return .failure(LocalEmployeesImageDataLoader.SaveError.failed)
    }

    private func expect(_ sut: LocalEmployeesImageDataLoader, toCompleteWith expectedResult: LocalEmployeesImageDataLoader.SaveResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        sut.save(anyData(), for: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.success, .success):
                break
                
            case (.failure(let receivedError as LocalEmployeesImageDataLoader.SaveError),
                  .failure(let expectedError as LocalEmployeesImageDataLoader.SaveError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
}

