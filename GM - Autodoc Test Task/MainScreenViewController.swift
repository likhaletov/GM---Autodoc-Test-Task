//
//  MainScreenViewController.swift
//  GM - Autodoc Test Task
//
//  Created by Dmitry Likhaletov on 14.09.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MainScreenViewController: UIViewController {
    
    private let networkService: NetworkService
    private let mapsService: MapsService
    private let locationManager = CLLocationManager()
    
    private let mainView = MainScreenView()
    
    private var dataSource: Users = []
    
    override func loadView() {
        view = mainView
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 12.0, *) {
            let userInterfaceStyle = traitCollection.userInterfaceStyle
            switch userInterfaceStyle {
            case .light:
                mainView.mapView.mapStyle = nil
            case .dark:
                activateDarkScheme()
            default:
                mainView.mapView.mapStyle = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 12.0, *) {
            setupInitScheme()
        }
        
        setupLocation()
        fetchLocations()
    }
    
    @available(iOS 12.0, *)
    private func setupInitScheme() {
        switch UIScreen.main.traitCollection.userInterfaceStyle {
        case .dark:
            print("init with dark")
            activateDarkScheme()
        case .light:
            print("init with light")
        default:
            print("init with default")
        }
    }
    
    private func activateDarkScheme() {
        do {
            if let styleURL = Bundle.main.url(forResource: Settings.GoogleMapsColorSchemes.dark, withExtension: "json") {
                mainView.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func fetchLocations() {
        guard let url = URL(string: Settings.api) else { return }
        networkService.getData(fromURL: url) { (response) in
            switch response {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let object = try decoder.decode(Users.self, from: data)
                    object.forEach { [weak self] in
                        let user = User(
                            idClient: $0.idClient,
                            idClientAccount: $0.idClientAccount,
                            clientCode: $0.clientCode,
                            latitude: $0.latitude,
                            longitude: $0.longitude,
                            avatarHash: $0.avatarHash,
                            statusOnline: $0.statusOnline
                        )
                        self?.dataSource.append(user)
                    }
                    self.addMarkers(with: self.dataSource)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func addMarkers(with user: Users) {
        DispatchQueue.main.async {
            user.forEach { [weak self] (item) in
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                marker.title = item.clientCode
                marker.map = self?.mainView.mapView
            }
        }
    }
    
    init(networkService: NetworkService, mapsService: MapsService) {
        self.networkService = networkService
        self.mapsService = mapsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainScreenViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        locationManager.startUpdatingLocation()
        mainView.mapView.isMyLocationEnabled = true
        mainView.mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        mainView.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
    }
}
