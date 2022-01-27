//
//  ViewController.swift
//  Weather
//
//  Created by Kirill Hobyan on 14.01.22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage(named: "background")
        cityNameLabel.isHidden = true
        weatherNameLabel.isHidden = true
        temperatureLabel.isHidden = true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))&appid=6af388cb3d01db22b93e5d8571601f9c"
        let url = URL(string: urlString)
        
        var locationName: String?, temperature: Double?, weatherName: String?
        
        let task = URLSession.shared.dataTask(with: url!) { data, responce, error in
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let _ = json["message"]{
                    let alert = UIAlertController(title: "Error", message: "Please enter correct city name", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okButton)
                    
                    DispatchQueue.main.async{
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else {
                
                    locationName = json["name"] as? String
                    
                    if let main = json["main"] {
                        temperature = main["temp"] as? Double
                    }
                    
                    if let weather = json["weather"] as? [[String: AnyObject]]{
                        weatherName = weather[0]["main"] as? String
                    }
                    
                    DispatchQueue.main.async {
                        self.cityNameLabel.isHidden = false
                        self.weatherNameLabel.isHidden = false
                        self.temperatureLabel.isHidden = false
                        
                        self.cityNameLabel.text = "🏠\(locationName!)"
                        self.weatherNameLabel.text = "☀️\(weatherName!)"
                        self.temperatureLabel.text = "🌡\(Int(temperature! - 273.15)) C°"
                    }
                    
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        
        task.resume()
        
    }

}

