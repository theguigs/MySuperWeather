//
//  EngineViewController.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 11/03/2023.
//

import UIKit
import Engine

class EngineViewController: UIViewController {
    let engine: Engine

    init(engine: Engine) {
        self.engine = engine
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
}
