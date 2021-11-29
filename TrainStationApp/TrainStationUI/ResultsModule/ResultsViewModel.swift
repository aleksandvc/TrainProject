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
   
    var trains = BindableArray<Train>([])
    
    var currentParsingElement = ""
    var trainStatus = TrainStatus.N
    var latitude = 0.0
    var longitude = 0.0
    var code = ""
    var date = ""
    var publicMessage = ""
    var direction = ""
    
    private func isSearchingCriterionMet(train: Train) -> Bool {
        //No need of date, because all the trains returned from the server are with today's date
        guard let fromStationData = UserDefaults.standard.object(forKey: UserDefaultsKeys.firstStation) as? Data, let toStationData = UserDefaults.standard.object(forKey: UserDefaultsKeys.secondStation) as? Data else {
            return false
        }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let fromStation = try? PropertyListDecoder().decode(Station.self, from: fromStationData), let toStation = try? PropertyListDecoder().decode(Station.self, from: toStationData) else {
            return false
        }
        let isCriterionMet = ((train.latitude == fromStation.latitude && train.longitude == fromStation.longitude) || (train.publicMessage.contains(fromStation.description))) && (train.direction.contains(toStation.description) || train.publicMessage.contains(toStation.description))
        return isCriterionMet
    }
    
    func getTrains(completion: ((String?) -> ())?) {
        NetworkManager.shared.getData(parserDelegate: self, shouldGetStations: false) { errorDescription in
            completion?(errorDescription)
        }
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
            
            if currentParsingElement == ResponceKeys.trainStatus {
                trainStatus = foundedChar == "N" ? TrainStatus.N : TrainStatus.R
                
            }
            else if currentParsingElement == ResponceKeys.trainLatitude {
                if let doubleLatitude = Double(foundedChar) {
                    latitude = doubleLatitude
                }
            }
            else if currentParsingElement == ResponceKeys.trainLongitude {
                if let doubleLongitude = Double(foundedChar) {
                    longitude = doubleLongitude
                }
            }
            else if currentParsingElement == ResponceKeys.trainCode {
                code = foundedChar
            }
            else if currentParsingElement == ResponceKeys.trainDate {
                date = foundedChar
            }
            else if currentParsingElement == ResponceKeys.publicMessage {
                publicMessage = foundedChar.replacingOccurrences(of: "\\n", with: " ")
            }
            else if currentParsingElement == ResponceKeys.trainDirection {
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
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
}
