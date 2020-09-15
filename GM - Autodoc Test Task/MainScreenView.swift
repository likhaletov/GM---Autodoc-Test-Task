//
//  MainScreenView.swift
//  GM - Autodoc Test Task
//
//  Created by Dmitry Likhaletov on 15.09.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit
import GoogleMaps

class MainScreenView: UIView {
    
    lazy var mapView: GMSMapView = {
        let view = GMSMapView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupMapView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMapView() {
        addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leftAnchor.constraint(equalTo: leftAnchor),
            mapView.rightAnchor.constraint(equalTo: rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
