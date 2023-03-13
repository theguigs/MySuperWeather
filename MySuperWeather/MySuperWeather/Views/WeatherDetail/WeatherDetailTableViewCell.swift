//
//  WeatherDetailTableViewCell.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import UIKit
import Engine

class WeatherDetailTableViewCell: UITableViewCell {
    static let kReuseIdentifier = "WeatherDetailTableViewCell"
    
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    @IBOutlet private weak var iconImageView: UIImageView!

    @IBOutlet private weak var tempMinLabel: UILabel!
    @IBOutlet private weak var tempMaxLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func configure(dayForecast: DayForecast) {
        configureDayLabel(dayForecast: dayForecast)
        configureTempsLabel(dayForecast: dayForecast)
        
        configureCurrentWeatherImageView(dayForecast: dayForecast)

    }
    
    private func configureDayLabel(dayForecast: DayForecast) {
        dayLabel.text = DateFormatter.shortDayFormatter.string(from: dayForecast.date)
        dateLabel.text = DateFormatter.dmFormatter.string(from: dayForecast.date)
    }
    
    private func configureTempsLabel(dayForecast: DayForecast) {
        guard let tempMin = dayForecast.main.tempMin,
              let tempMax = dayForecast.main.tempMax else { return }
        
        let tempMinMeasurement = Measurement(value: tempMin, unit: UnitTemperature.celsius)
        tempMinLabel.text = MeasurementFormatter.intWithUnitFormatter.string(from: tempMinMeasurement)
             
        let tempMaxMeasurement = Measurement(value: tempMax, unit: UnitTemperature.celsius)
        tempMaxLabel.text = MeasurementFormatter.intWithUnitFormatter.string(from: tempMaxMeasurement)
    }
    
    private func configureCurrentWeatherImageView(dayForecast: DayForecast) {
        guard let iconName = dayForecast.weather?.icon,
              let image = UIImage(named: iconName) else {
            return
        }
        
        iconImageView.image = image
    }
}
