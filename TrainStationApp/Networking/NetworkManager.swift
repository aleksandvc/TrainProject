//
//  NetworkManager.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 2.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import Foundation

class NetworkManager {
    
    weak var delegate: XMLParserDelegate?
    
    func getData(shouldGetStations: Bool, completion: (()->())?) {
        guard let url = URL(string: shouldGetStations ? AppEndPoints.getStationsURL : AppEndPoints.getTrainsURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            //TODO handle error
            guard let data = data else { return }
            let parser = XMLParser(data: data)
            parser.delegate = self.delegate
            parser.parse()
            completion?()
        })
        
        task.resume()
    }
}
