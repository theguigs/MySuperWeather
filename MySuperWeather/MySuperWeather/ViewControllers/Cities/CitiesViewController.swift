//
//  CitiesViewController.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 12/03/2023.
//

import UIKit

class CitiesViewController: EngineViewController {
    
    @IBOutlet private weak var emptyListView: UIView!
    @IBOutlet private weak var addCityButton: UIButton!

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emptyListView.isHidden = !engine.citiesService.cities.isEmpty
        tableView.isHidden = engine.citiesService.cities.isEmpty

        configureTableView()
        configureButton()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func configureButton() {
        addCityButton.layer.cornerRadius = 8.0
        addCityButton.layer.borderWidth = 1.0
    }
    
    @IBAction func addCityDidTouchUpInside(_ sender: Any) {
    }
}

extension CitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return engine.citiesService.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let city = engine.citiesService.cities[indexPath.row]
        cell.textLabel?.text = city.name
        return cell
    }
}
