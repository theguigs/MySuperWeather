//
//  CitiesViewController.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 12/03/2023.
//

import UIKit
import Engine

class CitiesViewController: EngineViewController {
    
    @IBOutlet private weak var emptyListView: UIView!
    @IBOutlet private weak var addCityButton: UIButton!

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureNavigationBar()
        
        showHideSections()

        configureTableView()
        configureButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    private func configureNavigationBar() {
        title = "Mes villes"
        
        let rightItem = UIBarButtonItem(image: UIImage(named: "plus"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(addCity))
        rightItem.tintColor = .black
        navigationItem.rightBarButtonItem = rightItem
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: CityTableViewCell.kReuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: CityTableViewCell.kReuseIdentifier)
    }
    
    private func configureButton() {
        addCityButton.layer.cornerRadius = 8.0
        addCityButton.layer.borderWidth = 2.0
    }
    
    private func showHideSections() {
        emptyListView.isHidden = !engine.citiesService.cities.isEmpty
        tableView.isHidden = engine.citiesService.cities.isEmpty
    }
    
    @objc func addCity() {
        let addCityViewController = AddCityViewController(engine: engine, delegate: self)
        present(addCityViewController, animated: true)
    }
    
    @IBAction func addCityDidTouchUpInside(_ sender: Any) {
        addCity()
    }
}

extension CitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return engine.citiesService.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CityTableViewCell.kReuseIdentifier,
            for: indexPath
        ) as? CityTableViewCell else {
            return UITableViewCell()
        }
        
        let city = engine.citiesService.cities[indexPath.row]
        let current = engine.weatherService.currentWeatherByCity[city]
        cell.configure(city: city, current: current)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = engine.citiesService.cities[indexPath.row]
        engine.weatherService.fetchHourlyWeather(city: city) { c, e in
            print(c)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let city = engine.citiesService.cities[indexPath.row]

        let delete = UIContextualAction(style: .destructive,
                                        title: "Supprimer") { [weak self] _, _, _ in
            guard let self else { return }
            
            self.engine.citiesService.cities.removeAll(where: { $0 == city })
            self.tableView.deleteRows(at: [indexPath], with: .left)
            
            self.showHideSections()
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension CitiesViewController: AddCityViewControllerDelegate {
    func addCityViewControllerDidAddCity(_ vc: AddCityViewController, city: GeocodedCity) {
        engine.weatherService.fetchCurrentWeather(city: city) { [weak self] current, error in
            guard let self else { return }
            
            self.showHideSections()
            self.tableView.reloadData()
        }
    }
}
