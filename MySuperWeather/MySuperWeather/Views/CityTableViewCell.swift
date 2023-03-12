//
//  CityTableViewCell.swift
//  MySuperWeather
//
//  Created by Guillaume Audinet on 12/03/2023.
//

import UIKit
import Engine

class CityTableViewCell: UITableViewCell {
    static let kReuseIdentifier = "CityTableViewCell"
    
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var coordinateLabel: UILabel!

    @IBOutlet private weak var currentWeatherImageView: UIImageView!
    @IBOutlet private weak var currentTemperatureLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        flagImageView.isHidden = false
        coordinateLabel.isHidden = false
        currentWeatherImageView.isHidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    func configure(city: GeocodedCity, current: Current? = nil) {
        configureFlagImageView(city: city)
        configureCityNameLabel(city: city)
        configureLatLonLabel(city: city)
        
        configureCurrentWeatherImageView(current: current)
        configureCurrentTemperatureLabel(current: current)
    }
    
    private func configureFlagImageView(city: GeocodedCity) {
        guard let country = city.country, let image = UIImage(named: country) else {
            flagImageView.isHidden = true
            return
        }
        
        flagImageView.image = image
    }
    
    private func configureCityNameLabel(city: GeocodedCity) {
        cityNameLabel.text = "\(city.name ?? ""), \(city.state ?? "")".trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func configureLatLonLabel(city: GeocodedCity) {
        guard let lat = city.lat, let lon = city.lon else {
            coordinateLabel.isHidden = true
            return
        }
                
        coordinateLabel.text = "\(lat.rounded(decimalCount: 4)), \(lon.rounded(decimalCount: 4))"
    }
    
    private func configureCurrentWeatherImageView(current: Current?) {
        guard let current = current,
              let iconName = current.weather?.first?.icon,
              let image = UIImage(named: iconName) else {
            currentWeatherImageView.isHidden = true
            return
        }
        
        currentWeatherImageView.image = image
    }
    
    private func configureCurrentTemperatureLabel(current: Current?) {
        guard let current = current,
              let temp = current.main?.temp else {
            return
        }
        
        let measurement = Measurement(value: temp, unit: UnitTemperature.celsius)
        
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .providedUnit

        currentTemperatureLabel.text = measurementFormatter.string(from: measurement)
    }
}
