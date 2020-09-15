//
//  UserModel.swift
//  GM - Autodoc Test Task
//
//  Created by Dmitry Likhaletov on 15.09.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation
import GoogleMapsUtils

class PointOfUser: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String
    var snippet: String?
    
    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
        self.snippet = name
    }
}
