//
//  HTTPClient.swift
//  Factory
//
//  Created by alok subedi on 13/08/2021.
//

import Foundation

 protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
