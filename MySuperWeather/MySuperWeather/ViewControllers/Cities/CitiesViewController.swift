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
        cell.configure(city: city)
        
        return cell
    }
}

extension CitiesViewController: AddCityViewControllerDelegate {
    func addCityViewControllerDidAddCity(_ vc: AddCityViewController) {
        showHideSections()
        tableView.reloadData()
    }
}
