//
//  MainViewController.swift
//  Weather API
//
//  Created by Антон Баландин on 6.09.24.
//

import UIKit

final class MainViewController: UIViewController, UITextFieldDelegate, TabBarControllerDelegate {
    let viewModel = WeatherViewModel()
    
    // MARK: - GUI Variables
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "FrankC", size: 50)
        label.textColor = .black
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "FrankC", size: 100)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var adviceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "FrankC", size: 35)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var weatherIcon = UIImageView()
    
    private lazy var cityNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите названия города"
        return textField
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.9
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        cityNameTextField.delegate = self
        
        viewModel.onUpdate = { [weak self] in
            self?.updateUI()
            
            if let tabBarController = self?.tabBarController as? TabBarController {
                if let forecastVC = tabBarController.viewControllers?[1] as? ForecastViewController {
                    forecastVC.cityName = self?.viewModel.weather?.name
                    self?.viewModel.fetchForecast(for: forecastVC.cityName ?? "")
                }
            }
            
        }
        
        viewModel.onAuthorizationDenied = { [weak self] in
            self?.showAlert(message: "Доступ к местоположению запрещён. Пожалуйста, разрешите доступ в настройках")
        }
        
        if let tabBarController = self.tabBarController as? TabBarController {
            tabBarController.delegateTabBar = self
        }
        updateUI()
    }
    
    // MARK: - Override Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Actions
    func didTapCenterButton() {
        guard let cityName = cityNameTextField.text, !cityName.isEmpty else {
            showAlert(message: "Пожалуйста, введите название города.")
            return
        }
        
        viewModel.fetchWeather(for: cityName)
        viewModel.fetchForecast(for: cityName)
        cityNameTextField.text = ""
    }
    
    // MARK: - Methods
    func updateUI() {
        
        if let city = viewModel.weather?.name{
            cityLabel.text = city
        }
        
        if let temp = viewModel.weather?.main.temp {
            let temp = Int(temp)
            temperatureLabel.text = "\(temp)°C"
        }
        adviceLabel.text = viewModel.advice
        
        if let icon = viewModel.weather?.weather.first?.icon {
            let imageName = viewModel.getWeatherIcon(for: icon)
            self.weatherIcon.image = UIImage(named: imageName)
        }
        
    }
}

// MARK: - Extension
extension MainViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        view.addSubview(cityLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(adviceLabel)
        view.addSubview(weatherIcon)
        view.addSubview(cityNameTextField)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        adviceLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        cityNameTextField.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            
            adviceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adviceLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            adviceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            adviceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            weatherIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherIcon.topAnchor.constraint(equalTo: adviceLabel.bottomAnchor, constant: 10),
            weatherIcon.widthAnchor.constraint(equalToConstant: 130),
            weatherIcon.heightAnchor.constraint(equalToConstant: 130),
            
            cityNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cityNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cityNameTextField.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 10),
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Внимание!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

