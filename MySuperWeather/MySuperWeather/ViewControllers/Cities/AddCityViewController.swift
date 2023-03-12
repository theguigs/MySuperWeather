//
//  AddCityViewController.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 12/03/2023.
//

import UIKit
import Engine

protocol AddCityViewControllerDelegate: AnyObject {
    func addCityViewControllerDidAddCity(_ vc: AddCityViewController, city: GeocodedCity)
}

class AddCityViewController: EngineViewController {

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!

    private let debouncer = Debouncer()
    private var geocodingResult: [GeocodedCity] = []
    
    private weak var delegate: AddCityViewControllerDelegate?
    
    init(engine: Engine, delegate: AddCityViewControllerDelegate?) {
        self.delegate = delegate
        
        super.init(engine: engine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTextField()
        configureTableView()
    }

    private func configureTextField() {
        searchTextField.delegate = self
        
        searchTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: CityTableViewCell.kReuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: CityTableViewCell.kReuseIdentifier)
    }
}

extension AddCityViewController: UITextFieldDelegate {
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        debouncer.debounce { [weak self] in
            guard let self, let query = textField.text else { return }
            
            self.engine.citiesService.fetchCities(for: query) { cities, error in
                self.geocodingResult = cities ?? []
                self.tableView.reloadData()
            }
        }
    }
}

extension AddCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geocodingResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CityTableViewCell.kReuseIdentifier,
            for: indexPath
        ) as? CityTableViewCell else {
            return UITableViewCell()
        }
        
        let city = geocodingResult[indexPath.row]
        cell.configure(city: city)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var city = geocodingResult[indexPath.row]
        city.id = UUID()
        
        engine.citiesService.cities.append(city)
        
        delegate?.addCityViewControllerDidAddCity(self, city: city)
        
        dismiss(animated: true)
    }
}
