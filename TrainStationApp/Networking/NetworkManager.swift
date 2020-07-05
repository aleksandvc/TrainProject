//
//  NetworkManager.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 2.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    weak var delegate: XMLParserDelegate?
    
    func getData(presenter: UIViewController, shouldGetStations: Bool, completion: (()->())?) {
        guard let url = URL(string: shouldGetStations ? AppEndPoints.getStationsURL : AppEndPoints.getTrainsURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error {
                let alert = UIAlertController(title: "Something went wrong", message: error.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                DispatchQueue.main.async {
                    presenter.present(alert, animated: false, completion: nil)
                }
            }
            
            guard let data = data else { return }
            let parser = XMLParser(data: data)
            parser.delegate = self.delegate
            parser.parse()
            completion?()
        })
        
        task.resume()
    }
}
