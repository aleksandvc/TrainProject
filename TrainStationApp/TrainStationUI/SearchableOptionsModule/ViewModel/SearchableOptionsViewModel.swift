//
//  SearchableOptionsViewModel.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 3.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import Foundation
import Bondage
import Alamofire

class SearchableOptionsViewModel: NSObject, SearchableOptionsNetworkingProtocol {
    
    var trainStations = BindableArray<Station>([])
    var searchedStations:[Station] = []
    
    var currentParsingElement = ""
    var stationDescription = ""
    var stationAlias = ""
    var stationLatitude = 0.0
    var stationLongitude = 0.0
    var stationCode = ""
    var stationId = 0
    
    var searchedTrainStations: [Station] {
        get {
            return searchedStations
        }
        set {
            searchedStations = newValue
        }
    }
    
    var isSearching = false
    
    //Order stations by description
    private func sortStations(unsortedStations: [Station]) {
        trainStations.value = unsortedStations.sorted(by: { $0.description < $1.description })
    }
    
    func getStations(completion: ((String?)->())?) {
        NetworkManager.shared.getData(parserDelegate: self, shouldGetStations: true) { errorDescription in
            completion?(errorDescription)
        }
    }
}

extension SearchableOptionsViewModel: XMLParserDelegate {
    
    //MARK:- XML Delegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentParsingElement = elementName
        if elementName == "ArrayOfObjStation" {
            print("Started parsing...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            
            if currentParsingElement == ResponceKeys.stationDecription {
                stationDescription = foundedChar
            }
            else if currentParsingElement == ResponceKeys.stationAlias {
                stationAlias = foundedChar
            }
            else if currentParsingElement == ResponceKeys.stationLatitude {
                if let doubleLatitude = Double(foundedChar) {
                    stationLatitude = doubleLatitude
                }
            }
            else if currentParsingElement == ResponceKeys.stationLongitude {
                if let doubleLongitude = Double(foundedChar) {
                    stationLongitude = doubleLongitude
                }
            }
            else if currentParsingElement == ResponceKeys.stationCode {
                stationCode = foundedChar
            }
            else if currentParsingElement == ResponceKeys.stationID {
                if let intId = Int(foundedChar) {
                    stationId = intId
                    let station = Station(description: stationDescription, alias: stationAlias, latitude: stationLatitude, longitude: stationLongitude, code: stationCode, id: stationId)
                    trainStations.value.append(station)
                }
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "ArrayOfObjStation" {
            print("Ended parsing...")
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.sortStations(unsortedStations: self.trainStations.value)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
}
