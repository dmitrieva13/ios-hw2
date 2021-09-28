//
//  SettingsViewController.swift
//  vadmitrievaPW2
//
//  Created by Varvara on 24.09.2021.
//

import UIKit
import CoreLocation

final class SettingsViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var viewController: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewController = navigationController?.viewControllers[0] as? ViewController
        if (viewController == nil) {
            setupCloseButton()
        }
        setupLocationToggle()
        setupSettingsView()
        locationManager.requestWhenInUseAuthorization()
    }
    
    private let locationTextView2 = UITextView()
    private let settingsView2 = UIView()
    private let locationManager = CLLocationManager()
    
    private func setupSettingsView() {
        self.view.addSubview(settingsView2)
        settingsView2.backgroundColor = .systemGray4
        settingsView2.translatesAutoresizingMaskIntoConstraints = false
        settingsView2.topAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.topAnchor,
        constant: 60
        ).isActive = true
        settingsView2.trailingAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
        constant: -10 ).isActive = true
        settingsView2.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                                              constant: 10).isActive = true
        settingsView2.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -10).isActive = true
    }
    
    private func setupLocationTextView() {
        self.view.addSubview(locationTextView2)
        locationTextView2.backgroundColor = .white
        locationTextView2.layer.cornerRadius = 20
        locationTextView2.translatesAutoresizingMaskIntoConstraints = false
        locationTextView2.topAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.topAnchor,
            constant: 60
        ).isActive = true
        locationTextView2.centerXAnchor.constraint(
            equalTo: self.view.centerXAnchor
        ).isActive = true
        locationTextView2.heightAnchor.constraint(equalToConstant: 300).isActive = true
        locationTextView2.leadingAnchor.constraint(
            equalTo: self.view.leadingAnchor,
            constant: 15
        ).isActive = true
        locationTextView2.isUserInteractionEnabled = false
    }
    
    let locationToggle = UISwitch()
    
    public func locationToggleState() -> Bool {
        return locationToggle.isOn
    }
    
    private func setupLocationToggle() {
        settingsView2.addSubview(locationToggle)
        if (viewController == nil) {
            viewController = self.presentingViewController?.children.first as? ViewController
        }
        if ((viewController?.locationToggleState()) == true) {
            locationToggle.setOn(true, animated: false)
        } else {
            locationToggle.setOn(false, animated: false)
        }
        locationToggle.translatesAutoresizingMaskIntoConstraints = false
        locationToggle.topAnchor.constraint(
            equalTo: settingsView2.topAnchor,
            constant: 50
        ).isActive = true
        locationToggle.trailingAnchor.constraint(
            equalTo: settingsView2.trailingAnchor,
            constant: -10 ).isActive = true
        locationToggle.addTarget(
            self,
            action: #selector(locationToggleSwitched),
            for: .valueChanged
        )
        
            let locationLabel = UILabel()
            settingsView2.addSubview(locationLabel)
            locationLabel.text = "Location"
            locationLabel.textColor = .black
            locationLabel.translatesAutoresizingMaskIntoConstraints = false
            locationLabel.bottomAnchor.constraint(
                equalTo: locationToggle.topAnchor,
                constant: -5
            ).isActive = true
            locationLabel.leadingAnchor.constraint(
                equalTo: locationToggle.leadingAnchor,
                constant: -20
            ).isActive = true
            locationLabel.trailingAnchor.constraint(
                equalTo: locationToggle.trailingAnchor,
                constant: 10 ).isActive = true
    }
    
    @objc
    func locationToggleSwitched(_ sender: UISwitch) {
        if sender.isOn {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy =
            kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                viewController?.locationTogglePressedInNewWindow(true)
            } else {
                sender.setOn(false, animated: true)
                viewController?.locationTogglePressedInNewWindow(false)
            }
        } else {
            locationTextView2.text = ""
            locationManager.stopUpdatingLocation()
            viewController?.locationTogglePressedInNewWindow(false)
        }
    }
    
    private func setupCloseButton() {
        let button = UIButton(type: .close)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -10 ).isActive = true
        button.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 10
        ).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalTo:
            button.heightAnchor).isActive = true
        button.addTarget(self, action: #selector(closeScreen),
            for: .touchUpInside)
     }
    
     @objc
     private func closeScreen() {
         viewController?.locationTogglePressedInNewWindow(self.locationToggleState())
         dismiss(animated: true, completion: nil)
     }
    
}

extension SettingsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let coord: CLLocationCoordinate2D = manager.location?.coordinate
        else {return}
        locationTextView2.text = "Coordinates = \(coord.latitude) \(coord.longitude)"
    }
}

