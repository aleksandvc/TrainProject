//
//  NetworkManager.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 2.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import Foundation

//Know that Singletons are considered as anty-pattern but for this simple app it is not a problem.
class NetworkManager {
    
    weak var delegate: XMLParserDelegate?
    
    func getAllStations() {
        guard let url = URL(string: "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML") else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            print(error ?? "No error")
            print(response ?? "No response")
            
            guard let data = data else { return }
            let parser = XMLParser(data: data)
            parser.delegate = self.delegate
            parser.parse()
            
        })
        
        task.resume()
    }
}
