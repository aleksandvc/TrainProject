//
//  SearchableOptionsViewModel.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 3.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import Foundation
import Bondage

class SearchableOptionsViewModel: NSObject, SearchableOptionsNetworkingProtocol {
    
    let networkManager = NetworkManager()
    
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
    
    override init() {
        super.init()
        networkManager.delegate = self
    }
    
    func getStations(presenter: UIViewController, completion: (()->())?) {
        networkManager.getData(presenter: presenter, shouldGetStations: true, completion: completion)
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
            
            if currentParsingElement == "StationDesc" {
                stationDescription = foundedChar
            }
            else if currentParsingElement == "StationAlias" {
                stationAlias = foundedChar
            }
            else if currentParsingElement == "StationLatitude" {
                if let doubleLatitude = Double(foundedChar) {
                    stationLatitude = doubleLatitude
                }
            }
            else if currentParsingElement == "StationLongitude" {
                if let doubleLongitude = Double(foundedChar) {
                    stationLongitude = doubleLongitude
                }
            }
            else if currentParsingElement == "StationCode" {
                stationCode = foundedChar
            }
            else if currentParsingElement == "StationId" {
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
