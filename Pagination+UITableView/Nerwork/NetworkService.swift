//
//  NetworkService.swift
//  Pagination+UITableView
//
//  Created by Igor on 30.11.2021.
//

import Foundation

final class NetworkService<T: Codable> {
    
    enum Result<T> {
        case success(T)
        case failed(Error)
    }
    
    func getData(newPage: Int, completion: @escaping ((Result<T>) -> Void)) {
        
        let url = URL(string: "https://hn.algolia.com/api/v1/search_by_date?tags=story&page=\(newPage)")!
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in

            DispatchQueue.main.async {
                
                if let error = error {
                    completion(.failed(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failed(NSError(domain: "Network error", code: 999)))
                    return
                }
                
                do {
                    
                    let jsonData = try JSONDecoder().decode(T.self, from: data)
                    
                    completion(.success(jsonData))
                    
                } catch {
                    
                    completion(.failed(error))
                }
            }
            
        }.resume()
    }
}
