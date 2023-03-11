//
//  ViewController.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 09/03/2023.
//

import UIKit

class ViewController: EngineViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        
        engine.weatherService.fetchData { Welcome, error in
            print("")
        }
    }
}
