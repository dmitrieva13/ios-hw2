//
//  ViewController.swift
//  vadmitrievaPW2
//
//  Created by Varvara on 24.09.2021.
//

import CoreLocation
import UIKit

class ViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barStyle = UIBarStyle.black
        // Do any additional setup after loading the view.
        setupLocationTextView()
        setupLocationToggle()
        
        setupSliders()
        setupSettingsView()
        setupSettingsButton()
        locationManager.requestWhenInUseAuthorization()
    }

    private let locationTextView = UITextView()
    private let settingsView = UIStackView()
    private let setView = UIView()
    private let locationManager = CLLocationManager()
    
    private var buttonCount = 0
    
    private func setupSettingsButton() {
        let settingsButton = UIButton(type: .system)
        view.addSubview(settingsButton)
        settingsButton.setImage(
        UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal),
        for: .normal
        )
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 15
        ).isActive = true
        settingsButton.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -15 ).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 30).isActive
        = true
        settingsButton.widthAnchor.constraint(equalTo:
        settingsButton.heightAnchor).isActive = true
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed),
        for: .touchUpInside)
    }
    
    @objc private func settingsButtonPressed() {
        switch buttonCount {
        case 0, 1:
            UIView.animate(withDuration: 0.1, animations: {
                self.setView.alpha = 1 - self.setView.alpha
            })
        case 2:
            navigationController?.pushViewController(
                SettingsViewController(),
                animated: true)
        case 3:
            present(SettingsViewController(), animated: true, completion: nil)
        default:
            buttonCount = -1
        }
        buttonCount += 1
    }
    
    private func setupSettingsView() {        view.addSubview(setView)
        setView.translatesAutoresizingMaskIntoConstraints = false
        setView.backgroundColor = .systemGray4
        setView.alpha = 0
        setView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 10
        ).isActive = true
        setView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -10 ).isActive = true
        setView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        setView.widthAnchor.constraint(
            equalTo: setView.heightAnchor,
            multiplier: 2.0/3.0
            ).isActive = true
        setView.addSubview(settingsView)
        settingsView.axis = .vertical
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.topAnchor.constraint(equalTo:
                                            setView.topAnchor).isActive = true
        settingsView.trailingAnchor.constraint(equalTo:
                                                setView.trailingAnchor).isActive = true
        settingsView.leadingAnchor.constraint(equalTo:
                                                setView.leadingAnchor).isActive = true
    }
    

private func setupLocationTextView() {
    view.addSubview(locationTextView)
    locationTextView.backgroundColor = .white
    locationTextView.layer.cornerRadius = 20
    locationTextView.translatesAutoresizingMaskIntoConstraints = false
    locationTextView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 60
    ).isActive = true
    locationTextView.centerXAnchor.constraint(
        equalTo: view.centerXAnchor
    ).isActive = true
    locationTextView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    locationTextView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor,
        constant: 15
    ).isActive = true
    locationTextView.isUserInteractionEnabled = false
}
    
    let locationToggle = UISwitch()
    
    public func locationTogglePressedInNewWindow (_ result: Bool) -> Void {
        locationToggle.setOn(result, animated: true)
        if locationToggle.isOn {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy =
            kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            } else {
                locationToggle.setOn(false, animated: true)
            }
        } else {
            locationTextView.text = ""
            locationManager.stopUpdatingLocation()
        }
    }
    
    public func locationToggleState() -> Bool {
        return locationToggle.isOn
    }
    
    private func setupLocationToggle() {
        let locationLabel = UILabel()
        settingsView.addArrangedSubview(locationLabel)
        locationLabel.text = "Location"
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.topAnchor.constraint(
            equalTo: settingsView.topAnchor,
            constant: 20
        ).isActive = true
        locationLabel.leadingAnchor.constraint(
            equalTo: settingsView.leadingAnchor,
            constant: 10
        ).isActive = true
        locationLabel.trailingAnchor.constraint(
            equalTo: settingsView.leadingAnchor,
            constant: -10 ).isActive = true
        //let locationToggle = UISwitch()
        settingsView.addArrangedSubview(locationToggle)
        locationToggle.translatesAutoresizingMaskIntoConstraints = false
        locationToggle.topAnchor.constraint(
            equalTo: settingsView.topAnchor,
            constant: 50
        ).isActive = true
        locationToggle.trailingAnchor.constraint(
            equalTo: settingsView.trailingAnchor,
            constant: -10 ).isActive = true
        locationToggle.addTarget(
            self,
            action: #selector(locationToggleSwitched),
            for: .valueChanged
        )
    }
    
    
    @objc func locationToggleSwitched(_ sender: UISwitch) {
        if sender.isOn {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy =
            kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            } else {
                sender.setOn(false, animated: true)
            }
        } else {
            locationTextView.text = ""
            locationManager.stopUpdatingLocation()
        }
    }
    
    private let sliders = [UISlider(), UISlider(), UISlider()]
    private let colors = ["Red", "Green", "Blue"]
    
    private func setupSliders() {
        var top = 80
        for i in 0..<sliders.count {
            let view = UIView()
            settingsView.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(
                equalTo: settingsView.leadingAnchor,
                constant: 10
            ).isActive = true
            view.trailingAnchor.constraint(
                equalTo: settingsView.trailingAnchor,
                constant: -10 ).isActive = true
            view.topAnchor.constraint(
                equalTo: settingsView.topAnchor,
                constant: CGFloat(top)
            ).isActive = true
            view.heightAnchor.constraint(equalToConstant: 30).isActive = true
            top += 40
            let label = UILabel()
            view.addSubview(label)
            label.text = colors[i]
            label.translatesAutoresizingMaskIntoConstraints = false
            label.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 5
            ).isActive = true
            label.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ).isActive = true
            label.widthAnchor.constraint(
                equalToConstant: 50
            ).isActive = true
            let slider = sliders[i]
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.addTarget(self, action:
                                #selector(sliderChangedValue), for: .valueChanged)
            view.addSubview(slider)
            slider.topAnchor.constraint(equalTo: view.topAnchor,
                                        constant: 5).isActive = true
            slider.heightAnchor.constraint(equalToConstant: 20).isActive = true
            slider.leadingAnchor.constraint(equalTo:
                                                label.trailingAnchor, constant: 10).isActive = true
            slider.trailingAnchor.constraint(equalTo:
                                                view.trailingAnchor).isActive = true
        }
     }
            
    @objc private func sliderChangedValue() {
        let red: CGFloat = CGFloat(sliders[0].value)
        let green: CGFloat = CGFloat(sliders[1].value)
        let blue: CGFloat = CGFloat(sliders[2].value)
        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let coord: CLLocationCoordinate2D = manager.location?.coordinate
        else {return}
        locationTextView.text = "Coordinates = \(coord.latitude) \(coord.longitude)"
    }
}

