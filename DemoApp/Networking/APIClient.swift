//
//  APIClient.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 15.11.2024.
//

import Alamofire

// MARK: - APIClient Singleton
class APIClient {
    static let shared = APIClient()
    
    private init() {}
    
    // Base URL for the API
    private let baseURL = "https://api.json-generator.com/templates/"
    
    // Generic Request Method with async/await
    func request<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async throws -> T {
        // Construct the full URL
        let url = baseURL + endpoint.path + endpoint.suffix
            
        // Make a concurrent request using Alamofire
        return try await AF.request(url, headers: endpoint.headers)
            .validate()
            .serializingDecodable(T.self, automaticallyCancelling: true)
            .value
    }
}
