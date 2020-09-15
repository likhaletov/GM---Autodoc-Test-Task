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
import GoogleMapsUtils

class MainScreenViewController: UIViewController {
    
    private let networkService: NetworkService
    private let locationManager = CLLocationManager()
    private var clusterManager: GMUClusterManager? = nil
    
    private let mainView = MainScreenView()
    
    private var userDataSource: [PointOfUser] = []
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: - ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 12.0, *) { setupInitScheme() }
        fetchLocations()
        setupLocation()
    }
    
    // MARK: - Dark Scheme
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
    
    // MARK: - Setup Core Location
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Parsing JSON, creating user objects
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
                        let userPointsOfInterest = PointOfUser(
                            position: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude),
                            name: $0.clientCode
                        )
                        
                        self?.userDataSource.append(userPointsOfInterest)
                    }
                    self.setupClustering(with: self.userDataSource)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Clustering
    private func setupClustering(with poi: [PointOfUser]) {
        DispatchQueue.main.async {
            let mapView = self.mainView.mapView
            
            let iconGenerator = GMUDefaultClusterIconGenerator()
            let algorithm = GMUGridBasedClusterAlgorithm()
            let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
            
            self.clusterManager = GMUClusterManager(
                map: mapView,
                algorithm: algorithm,
                renderer: renderer
            )
            
            self.mainView.mapView.clear()
            self.clusterManager?.add(poi)
            self.clusterManager?.cluster()
            self.clusterManager?.setMapDelegate(self)
        }
    }
    
    // MARK: - Initializer
    init(networkService: NetworkService) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Core Location Manager Delegate
extension MainScreenViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mainView.mapView.isMyLocationEnabled = true
            mainView.mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        mainView.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 9, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - Google Maps Map Delegate
extension MainScreenViewController: GMSMapViewDelegate {
    
}
