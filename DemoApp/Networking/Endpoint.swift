//
//  Endpoint.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 15.11.2024.
//

import Alamofire

protocol Endpoint {
    var path: String { get }
    var suffix: String { get }
    var headers: HTTPHeaders? { get }
}

extension Endpoint {
    var headers: HTTPHeaders? {
        var headers = HTTPHeaders(["Content-Type": "application/json"])
        headers.add(.authorization("Bearer b3kgsqs1kqytlpact6fhh6pd8grvdj7kqm0nkvd1")) //Yeah, I know it's not safe to store token in code, but it's just a demo app and I don't want to spend time on setting up Keychain or hiding it in another way(.plist file for example).
        return headers // Default headers
    }
    
    var suffix: String {
        return "/data" // Default suffix
    }
}

