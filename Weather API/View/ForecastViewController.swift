//
//  ForecastViewController.swift
//  Weather API
//
//  Created by Антон Баландин on 6.09.24.
//

import UIKit

final class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Public Properties
    private var viewModel = WeatherViewModel()
    private let tableView = UITableView()
    
    var cityName: String?
    
    // MARK: - GUI Variables
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
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onAuthorizationDenied = { [weak self] in
            self?.showAlert(message: "Доступ к местоположению запрещён. Пожалуйста, разрешите доступ в настройках")
        }
        
        if let city = self.cityName {
            viewModel.fetchForecast(for: city)
        }
        
        
        if let mainVC = self.tabBarController?.viewControllers?.first as? MainViewController {
            viewModel = mainVC.viewModel
            viewModel.onUpdate = { [weak self] in
                mainVC.updateUI()
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forecast?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "FrankC", size: 17)
        cell.selectionStyle = .none
        
        if let forecastItem = viewModel.forecast?.list[indexPath.row] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, HH:mm"
            let dateString = dateFormatter.string(from: forecastItem.date)
            
            let temp = Int(forecastItem.main.temp)
            let description = forecastItem.weather.first?.description ?? ""
            
            cell.textLabel?.text = "\(dateString): \(temp)°C, \(description.capitalized)"
        }
        
        return cell
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(backgroundImageView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
        view.sendSubviewToBack(backgroundImageView)
        
        setupConstraints()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.backgroundColor = UIColor.clear
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Внимание!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
