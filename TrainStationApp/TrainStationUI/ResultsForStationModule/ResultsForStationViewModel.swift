//
//  ResultsForStationViewModel.swift
//  TrainStationApp
//
//  Created by Sasha Belov on 28.11.21.
//  Copyright © 2021 alexander.tsvetanov. All rights reserved.
//

import Foundation
import Bondage

class ResultsForStationViewModel: NSObject, ResultsForStationNetworkingProtocol {
    
    var trains = BindableArray<StationData>([])
    
    var selectedStation: Station?
    
    var currentParsingElement = ""
    var direction = ""
    var trainCode = ""
    var destination = ""
    var expectedArrival = ""
    
    init(selectedStation: Station) {
        self.selectedStation = selectedStation
    }
    
    func getTrains(completion: ((String?) -> ())?) {
        NetworkManager.shared.getTrainsForStation(stationDescription: selectedStation?.description ?? "", parserDelegate: self) { errorDescription in
            completion?(errorDescription)
        }
    }
}

extension ResultsForStationViewModel: XMLParserDelegate {
    
    //MARK:- XML Delegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentParsingElement = elementName
        if elementName == "ArrayOfObjStationData" {
            print("Started parsing...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == ResponceKeys.stationDataTrainCode {
                trainCode = foundedChar
            }
            else if currentParsingElement == ResponceKeys.trainDestination {
                destination = foundedChar
            }
            else if currentParsingElement == ResponceKeys.expectedArrival {
                expectedArrival = foundedChar
            }
            else if currentParsingElement == ResponceKeys.trainDirection{
                direction = foundedChar
                let stationData = StationData(trainCode: trainCode, direction: direction, destination: destination, expectedArrival: expectedArrival)
                trains.value.append(stationData)
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "ArrayOfObjStationData" {
            print("Ended parsing...")
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
}

