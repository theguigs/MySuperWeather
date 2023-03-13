//
//  WeatherDetailViewController.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import UIKit
import Engine

class WeatherDetailViewController: EngineViewController {
    @IBOutlet private weak var tableView: UITableView!

    let city: GeocodedCity
    let forecast: Forecast

    var datasource: [DayForecast] {
        return engine.weatherService.dailyForecastWeatherByCity[city]?.dailies ?? []
    }
    
    init(engine: Engine, city: GeocodedCity, forecast: Forecast) {
        self.city = city
        self.forecast = forecast

        super.init(engine: engine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: WeatherDetailTableViewCell.kReuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: WeatherDetailTableViewCell.kReuseIdentifier)

    }
}

extension WeatherDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WeatherDetailTableViewCell.kReuseIdentifier,
            for: indexPath
        ) as? WeatherDetailTableViewCell else {
            return UITableViewCell()
        }
        
        let dayForecast = datasource[indexPath.row]
        cell.configure(dayForecast: dayForecast)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}
