//
//  MainScreenViewController.swift
//  GM - Autodoc Test Task
//
//  Created by Dmitry Likhaletov on 14.09.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    let networkService = NetworkServiceImplementation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocations()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemPink
    }
    
    private func fetchLocations() {
        guard let url = URL(string: Settings.api) else { return }
        networkService.getData(fromURL: url) { (response) in
            switch response {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                print(data)
                let decoder = JSONDecoder()
                do {
                    let object = try decoder.decode(Users.self, from: data)
                    print("Items in JSON: \(object.count)")
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }


}
