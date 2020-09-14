//
//  MainScreenViewController.swift
//  GM - Autodoc Test Task
//
//  Created by Dmitry Likhaletov on 14.09.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    let networkService: NetworkService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocations()
        setupUI()
    }
    
    private func setupUI() {
        
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

    init(networkService: NetworkService) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
