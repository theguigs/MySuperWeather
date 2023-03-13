//
//  WeatherMacroDetailTableViewCell.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import UIKit
import Engine

class WeatherMacroDetailTableViewCell: UITableViewCell {
    static let kReuseIdentifier = "WeatherMacroDetailTableViewCell"
    
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    @IBOutlet private weak var iconImageView: UIImageView!

    @IBOutlet private weak var tempMinLabel: UILabel!
    @IBOutlet private weak var tempMaxLabel: UILabel!

    @IBOutlet private weak var cloudPercentageLabel: UILabel!
    @IBOutlet private weak var rainPercentageLabel: UILabel!
    @IBOutlet private weak var rainQuantityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func configure(dayForecast: DayForecast) {
        configureDayLabel(dayForecast: dayForecast)
        configureTempsLabel(dayForecast: dayForecast)
        
        configureCurrentWeatherImageView(dayForecast: dayForecast)
        
        configureCloudPercentageLabel(dayForecast: dayForecast)
        configureRainPercentageLabel(dayForecast: dayForecast)
        configureRainQuantityLabel(dayForecast: dayForecast)
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
    
    private func configureCloudPercentageLabel(dayForecast: DayForecast) {
        guard let cloudsPercentage = dayForecast.clouds.all else { return }
        cloudPercentageLabel.text = "\(cloudsPercentage) %"
    }
    
    private func configureRainPercentageLabel(dayForecast: DayForecast) {
        guard let humidityPercentage = dayForecast.main.humidity else { return }
        rainPercentageLabel.text = "\(humidityPercentage) %"
    }

    private func configureRainQuantityLabel(dayForecast: DayForecast) {
        let rainQuantity = dayForecast.rain.forThreeHours ?? 0.0
        rainQuantityLabel.text = "\(rainQuantity.rounded(decimalCount: 1)) mm"
    }
}
