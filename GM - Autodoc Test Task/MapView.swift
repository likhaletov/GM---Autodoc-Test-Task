//
//  MapView.swift
//  GM - Autodoc Test Task
//
//  Created by Dmitry Likhaletov on 15.09.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation
import GoogleMaps

class MapView: GMSMapView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        if frame == .zero {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
