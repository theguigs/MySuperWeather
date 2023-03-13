//
//  WeatherMicroDetailViewController.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import UIKit
import Engine

class WeatherMicroDetailViewController: EngineViewController {

    @IBOutlet private weak var tableView: UITableView!

    let city: GeocodedCity
    let date: Date

    var datasource: [Forecast.List] {
        let list = engine.weatherService.forecastWeatherByCity[city]?.list ?? []
        let calendar = Calendar.current
        
        return list.filter({ calendar.isDate($0.date, inSameDayAs: date )})
    }

    init(engine: Engine, city: GeocodedCity, date: Date) {
        self.city = city
        self.date = date
        
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
        title = DateFormatter.longDateFormatter.string(from: date)
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: WeatherMicroDetailTableViewCell.kReuseIdentifier, bundle: nil),
                           forCellReuseIdentifier: WeatherMicroDetailTableViewCell.kReuseIdentifier)

    }
}

extension WeatherMicroDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WeatherMicroDetailTableViewCell.kReuseIdentifier,
            for: indexPath
        ) as? WeatherMicroDetailTableViewCell else {
            return UITableViewCell()
        }
        
        let listElement = datasource[indexPath.row]
        cell.configure(listElement: listElement)

        return cell
    }
}
