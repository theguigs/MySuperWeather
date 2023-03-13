//
//  WeatherMicroDetailTableViewCell.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import UIKit
import Engine

class WeatherMicroDetailTableViewCell: UITableViewCell {
    static let kReuseIdentifier = "WeatherMicroDetailTableViewCell"
    
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!

    @IBOutlet private weak var iconImageView: UIImageView!

    @IBOutlet private weak var tempLabel: UILabel!

    @IBOutlet private weak var cloudPercentageLabel: UILabel!
    @IBOutlet private weak var rainPercentageLabel: UILabel!
    @IBOutlet private weak var rainQuantityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(listElement: Forecast.List) {
        configureDayLabel(listElement: listElement)
        configureTempsLabel(listElement: listElement)
        
        configureCurrentWeatherImageView(listElement: listElement)
        
        configureCloudPercentageLabel(listElement: listElement)
        configureRainPercentageLabel(listElement: listElement)
        configureRainQuantityLabel(listElement: listElement)
    }
    
    private func configureDayLabel(listElement: Forecast.List) {
        let startTime = listElement.date
        let endTime = listElement.date.addingTimeInterval(TimeInterval.hours(3))

        startTimeLabel.text = DateFormatter.shortTimeFormatter.string(from: startTime)
        endTimeLabel.text = DateFormatter.shortTimeFormatter.string(from: endTime)
    }
    
    private func configureTempsLabel(listElement: Forecast.List) {
        guard let temp = listElement.main?.temp else { return }
        
        let tempMinMeasurement = Measurement(value: temp, unit: UnitTemperature.celsius)
        tempLabel.text = MeasurementFormatter.intWithUnitFormatter.string(from: tempMinMeasurement)
    }
    
    private func configureCurrentWeatherImageView(listElement: Forecast.List) {
        guard let iconName = listElement.weather?.first?.icon,
              let image = UIImage(named: iconName) else {
            return
        }
        
        iconImageView.image = image
    }

    private func configureCloudPercentageLabel(listElement: Forecast.List) {
        guard let cloudsPercentage = listElement.clouds?.all else { return }
        cloudPercentageLabel.text = "\(cloudsPercentage) %"
    }
    
    private func configureRainPercentageLabel(listElement: Forecast.List) {
        guard let humidityPercentage = listElement.main?.humidity else { return }
        rainPercentageLabel.text = "\(humidityPercentage) %"
    }

    private func configureRainQuantityLabel(listElement: Forecast.List) {
        let rainQuantity = listElement.rain?.forThreeHours ?? 0.0
        rainQuantityLabel.text = "\(rainQuantity.rounded(decimalCount: 1)) mm"
    }
}
