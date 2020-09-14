//
//  NetworkService.swift
//  GM - Autodoc Test Task
//
//  Created by Dmitry Likhaletov on 14.09.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

class NetworkServiceImplementation: NetworkService {
    
    func getData(fromURL url: URL, completionHandler: @escaping ((Result<Data, Error>) -> Void)) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data,
                let response = response else { return }
            
            if let error = error {
                completionHandler(.failure(error))
                return
            } else {
                completionHandler(.success(data))
            }
            
        }
        task.resume()
    }
    
}
