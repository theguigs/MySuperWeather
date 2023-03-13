//
//  WeatherMacroDetailViewController.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import UIKit
import Engine

class WeatherMacroDetailViewController: EngineViewController {
    @IBOutlet private weak var tableView: UITableView!

    let city: GeocodedCity

    var datasource: [DayForecast] {
        return engine.weatherService.dailyForecastWeatherByCity[city]?.dailies ?? []
    }
    
    init(engine: Engine, city: GeocodedCity) {
        self.city = city

        super.init(engine: engine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        title = city.name ?? ""
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: WeatherMacroDetailTableViewCell.kReuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: WeatherMacroDetailTableViewCell.kReuseIdentifier)

    }
}

extension WeatherMacroDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WeatherMacroDetailTableViewCell.kReuseIdentifier,
            for: indexPath
        ) as? WeatherMacroDetailTableViewCell else {
            return UITableViewCell()
        }
        
        let dayForecast = datasource[indexPath.row]
        cell.configure(dayForecast: dayForecast)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let dayForecast = datasource[indexPath.row]
        let weatherMicroDetailViewController = WeatherMicroDetailViewController(
            engine: engine,
            city: city,
            date: dayForecast.date
        )
        navigationController?.pushViewController(weatherMicroDetailViewController, animated: true)
    }
}
