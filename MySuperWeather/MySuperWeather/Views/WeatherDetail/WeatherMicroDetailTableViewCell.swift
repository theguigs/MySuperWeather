//
//  WeatherMicroDetailTableViewCell.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 13/03/2023.
//

import UIKit
import Engine

extension Int {
    var deg2rad: CGFloat {
        return CGFloat(self)  * .pi / 180
    }
}

class WeatherMicroDetailTableViewCell: UITableViewCell {
    static let kReuseIdentifier = "WeatherMicroDetailTableViewCell"
    
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!

    @IBOutlet private weak var iconImageView: UIImageView!

    @IBOutlet private weak var tempLabel: UILabel!

    @IBOutlet private weak var cloudPercentageLabel: UILabel!
    @IBOutlet private weak var rainPercentageLabel: UILabel!
    @IBOutlet private weak var rainQuantityLabel: UILabel!

    @IBOutlet private weak var windArrowImageView: UIImageView!
    @IBOutlet private weak var windSpeedLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        windArrowImageView.transform = windArrowImageView.transform.rotated(by: .pi / 2)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        selectionStyle = .none
        windArrowImageView.transform = windArrowImageView.transform.rotated(by: .pi / 2)
    }
    
    func configure(listElement: Forecast.List) {
        configureDayLabel(listElement: listElement)
        configureTempsLabel(listElement: listElement)
        
        configureCurrentWeatherImageView(listElement: listElement)
        
        configureCloudPercentageLabel(listElement: listElement)
        configureRainPercentageLabel(listElement: listElement)
        configureRainQuantityLabel(listElement: listElement)
        
        configureSpeedImageView(listElement: listElement)
        configureSpeedLabel(listElement: listElement)
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
    
    private func configureSpeedImageView(listElement: Forecast.List) {
        let windRotation = listElement.wind?.deg ?? 0
        windArrowImageView.transform = windArrowImageView.transform.rotated(by: windRotation.deg2rad)
    }
    
    private func configureSpeedLabel(listElement: Forecast.List) {
        let windRotation = Int(listElement.wind?.speed ?? 0.0)
        windSpeedLabel.text = windRotation.description
    }
}
