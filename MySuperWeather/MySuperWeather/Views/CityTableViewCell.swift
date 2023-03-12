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

    override func prepareForReuse() {
        super.prepareForReuse()
        
        flagImageView.isHidden = false
        coordinateLabel.isHidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    func configure(city: City) {
        configureFlagImageView(city: city)
        configureCityNameLabel(city: city)
        configureLatLonLabel(city: city)
    }
    
    private func configureFlagImageView(city: City) {
        guard let country = city.country, let image = UIImage(named: country) else {
            flagImageView.isHidden = true
            return
        }
        
        flagImageView.image = image
    }
    
    private func configureCityNameLabel(city: City) {
        cityNameLabel.text = "\(city.name ?? ""), \(city.state ?? "")".trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func configureLatLonLabel(city: City) {
        guard let lat = city.lat, let lon = city.lon else {
            coordinateLabel.isHidden = true
            return
        }
        
        coordinateLabel.text = "\(lat), \(lon)"
    }
}
