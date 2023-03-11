//
//  ViewController.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 09/03/2023.
//

import UIKit
import Engine

class ViewController: EngineViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        
        
//        engine.weatherService.fetchCurrentWeather { d, e in
//            print("")
//        }
        
        engine.citiesService.fetchCities(for: "Paris") { cities, error in
            print("")
        }
    }
}
