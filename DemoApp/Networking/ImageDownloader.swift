//
//  ImageDownloader.swift
//  DemoApp
//
//  Created by Vladyslav Prosianyk on 20.11.2024.
//

import Foundation
import UIKit

// MARK: - Error Definitions
enum ImageDownloadError: Error, LocalizedError {
    case invalidURL
    case invalidData(String)
    case dataNotExist
    case badResponseCode(Int)
    case responseDidntCasted
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .invalidData(let convertedStringData):
            return "The data received is invalid or corrupted. Data: \(convertedStringData)"
        case .dataNotExist:
            return "The data does not exist"
        case .badResponseCode(let responseCode):
            return "The response code \(responseCode) is not in the 200 range."
        case .responseDidntCasted:
            return "The response did not cast to HTTPURLResponse"
        }
    }
}

// MARK: - ImageDownloader Service
class ImageDownloader {
    static let shared = ImageDownloader()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func downloadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = cache.object(forKey: NSString(string: urlString)) {
            completion(.success(cachedImage))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(ImageDownloadError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse
            else {
                completion(.failure(ImageDownloadError.responseDidntCasted))
                return
            }
            
            guard
                (200...299).contains(httpResponse.statusCode)
            else {
                completion(.failure(ImageDownloadError.badResponseCode(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(ImageDownloadError.dataNotExist))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(ImageDownloadError.invalidData(String(data: data, encoding: .utf8) ?? "bad data conversion")))
                return
            }
            
            self?.cache.setObject(image, forKey: NSString(string: urlString))
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        task.resume()
    }
    
    func clearCache(for urlString: String) {
        cache.removeObject(forKey: NSString(string: urlString))
    }
}
