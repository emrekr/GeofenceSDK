//
//  ViewController.swift
//  GeofenceExampleApp
//
//  Created by Emre Kuru on 29.01.2025.
//

import UIKit
import GeofenceSDK

class ViewController: UIViewController {
    
    private let startGeofenceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Geofence", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.addTarget(nil, action: #selector(startGeofenceTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var infoTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(startGeofenceButton)
        view.addSubview(infoTextLabel)
        startGeofenceButton.translatesAutoresizingMaskIntoConstraints = false
        infoTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startGeofenceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startGeofenceButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startGeofenceButton.widthAnchor.constraint(equalToConstant: 150),
            startGeofenceButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        NSLayoutConstraint.activate([
            infoTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoTextLabel.bottomAnchor.constraint(equalTo: startGeofenceButton.topAnchor, constant: -20),
            infoTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc private func startGeofenceTapped(_ sender: UIButton) {
        GeoSDK.shared.startGeofenceMonitoring()
        GeoSDK.shared.delegate = self
    }
}


extension ViewController: GeoGeofenceSDKDelegate {
    func geofenceSdk(_ sdk: GeofenceSDK.GeoSDK, didEnterGeofenceWithIdentifier identifier: String) {
        infoTextLabel.text = "You have entered \(identifier)."
    }
    
    func geofenceSdk(_ sdk: GeofenceSDK.GeoSDK, didExitGeofenceWithIdentifier identifier: String) {
        infoTextLabel.text = "You have exited \(identifier)."
    }
    
    
}
