//
//  ScreenAssembly.swift
//  GM - Autodoc Test Task
//
//  Created by Dmitry Likhaletov on 14.09.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

protocol ScreenAssembly: AnyObject {
    static func assemblyMainScreen() -> UIViewController
}

class ScreenAssemblyImplementation: ScreenAssembly {
    static func assemblyMainScreen() -> UIViewController {
        let networkService = NetworkServiceImplementation()
        let viewController = MainScreenViewController(networkService: networkService)
        return viewController
    }
}
