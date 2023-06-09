//
//  AppDelegate.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 09/03/2023.
//

import UIKit
import Engine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var engine: Engine?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let baseURL = URL(string: "https://api.openweathermap.org") else {
            fatalError("Base URL is not a valid URL")
        }
        
        window = UIWindow()
        
        let network = EngineConfiguration.Network(baseUrl: baseURL)
        let configuration = EngineConfiguration(network: network)
        
        let engine = Engine(configuration: configuration)
        self.engine = engine

        let citiesViewController = CitiesViewController(engine: engine)
        let navController = UINavigationController(rootViewController: citiesViewController)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}

