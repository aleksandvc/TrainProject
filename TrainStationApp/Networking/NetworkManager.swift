//
//  NetworkManager.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 2.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class NetworkManager {
    private static var networkManager: NetworkManager!
    
    static var shared: NetworkManager {
        get {
            if networkManager == nil {
                networkManager = NetworkManager()
            }
            return networkManager
        }
    }
    
    func getData(parserDelegate: XMLParserDelegate, shouldGetStations: Bool, completion: ((String?)->())?) {
        let url = shouldGetStations ? AppEndPoints.getStationsURL : AppEndPoints.getTrainsURL
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default).response { response in
            switch response.result {
            case .success(let value):
                guard let responceData = value else  { return }
                let parser = XMLParser(data: responceData)
                parser.delegate = parserDelegate
                parser.parse()
                completion?(nil)
                
            case .failure(let error):
                completion?(error.localizedDescription)
            }
        }
    }
    
    func getTrainsForStation(stationDescription: String, parserDelegate: XMLParserDelegate, completion: ((String?)->())?) {
        let url = AppEndPoints.getTrainsForStation
        let parameters = ["StationDesc": stationDescription]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).response { response in
            switch response.result {
            case .success(let value):
                guard let responceData = value else  { return }
                let parser = XMLParser(data: responceData)
                parser.delegate = parserDelegate
                parser.parse()
                completion?(nil)
            case .failure(let error):
                completion?(error.localizedDescription)
            }
        }
        
        
    }
}
