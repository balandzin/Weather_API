//
//  TabBarController.swift
//  Weather API
//
//  Created by Антон Баландин on 6.09.24.
//

import UIKit
protocol TabBarControllerDelegate: AnyObject {
    func didTapCenterButton()
}

final class TabBarController: UITabBarController {
    
    weak var delegateTabBar: TabBarControllerDelegate?
    private let centerButton = UIButton(type: .custom)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupCenterButton()
    }
    
    // MARK: - Private Methods
    private func setupTabBar() {
        let mainVC = MainViewController()
        mainVC.tabBarItem = UITabBarItem(
            title: "Main",
            image: UIImage(named: "main")?.withRenderingMode(.alwaysOriginal),
            selectedImage: nil
        )
        
        let forecastVC = ForecastViewController()
        forecastVC.tabBarItem = UITabBarItem(
            title: "Forecast",
            image: UIImage(named: "forecast")?.withRenderingMode(.alwaysOriginal),
            selectedImage: nil
        )
        
        viewControllers = [mainVC, forecastVC]
        
        tabBar.tintColor = .black
    }
    
    private func setupCenterButton() {
        centerButton.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        centerButton.backgroundColor = .funnyLight
        centerButton.layer.cornerRadius = 35
        centerButton.setImage(UIImage(systemName: "plus"), for: .normal)
        centerButton.tintColor = .white
        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        
        _ = tabBar.bounds.height
        centerButton.center = CGPoint(x: tabBar.bounds.width / 2, y: tabBar.bounds.height / 2 - 20)
        tabBar.addSubview(centerButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerButton.widthAnchor.constraint(equalToConstant: 70),
            centerButton.heightAnchor.constraint(equalToConstant: 70),
            centerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }
    
    // MARK: - Objc Methods
    @objc private func centerButtonTapped() {
        delegateTabBar?.didTapCenterButton()
    }
}
