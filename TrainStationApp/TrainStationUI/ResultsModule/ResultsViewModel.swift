//
//  ResultsViewModel.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 4.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import Foundation
import Bondage

class ResultsViewModel: NSObject, ResultsNetworkingProtocol {
   
    let networkManager = NetworkManager()
    
    var trains = BindableArray<Train>([])
    
    var currentParsingElement = ""
    var trainStatus = TrainStatus.N
    var latitude = 0.0
    var longitude = 0.0
    var code = ""
    var date = ""
    var publicMessage = ""
    var direction = ""
    
    override init() {
        super.init()
        networkManager.delegate = self
    }
    
    func isSearchingCriterionMet(train: Train) -> Bool {
        guard let fromStationData = UserDefaults.standard.object(forKey: UserDefaultsKeys.fromStation) as? Data, let toStationData = UserDefaults.standard.object(forKey: UserDefaultsKeys.toStation) as? Data else {
            return false
        }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let fromStation = try? PropertyListDecoder().decode(Station.self, from: fromStationData), let toStation = try? PropertyListDecoder().decode(Station.self, from: toStationData) else {
            return false
        }
        
        return train.latitude == fromStation.latitude && train.longitude == fromStation.longitude && (train.direction.contains(toStation.description) || train.publicMessage.contains(toStation.description))
    }
    
    func getTrains(presenter: UIViewController, completion: (() -> ())?) {
        networkManager.getData(presenter: presenter, shouldGetStations: false, completion: completion)
    }
}

extension ResultsViewModel: XMLParserDelegate {
    
    //MARK:- XML Delegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentParsingElement = elementName
        if elementName == "ArrayOfObjTrainPositions" {
            print("Started parsing...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            
            if currentParsingElement == "TrainStatus" {
                trainStatus = foundedChar == "N" ? TrainStatus.N : TrainStatus.R
                
            }
            else if currentParsingElement == "TrainLatitude" {
                if let doubleLatitude = Double(foundedChar) {
                    latitude = doubleLatitude
                }
            }
            else if currentParsingElement == "TrainLongitude" {
                if let doubleLongitude = Double(foundedChar) {
                    longitude = doubleLongitude
                }
            }
            else if currentParsingElement == "TrainCode" {
                code = foundedChar
            }
            else if currentParsingElement == "TrainDate" {
                date = foundedChar
            }
            else if currentParsingElement == "PublicMessage" {
                publicMessage = foundedChar.replacingOccurrences(of: "\\n", with: " ")
            }
            else if currentParsingElement == "Direction" {
                direction = foundedChar
                let train = Train(trainStatus: trainStatus, latitude: latitude, longitude: longitude, code: code, date: date, publicMessage: publicMessage, direction: direction)
                if isSearchingCriterionMet(train: train) {
                    trains.value.append(train)
                }
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "ArrayOfObjTrainPositions" {
            print("Ended parsing...")
            print(trains.value.count)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
}
