//
//  NetworkService.swift
//  GM - Autodoc Test Task
//
//  Created by Dmitry Likhaletov on 14.09.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

protocol NetworkService {
    func getData(fromURL url: URL, completionHandler: @escaping ((Result<Data, Error>) -> Void))
}
