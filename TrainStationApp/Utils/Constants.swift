//
//  Constants.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 2.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import Foundation

struct UserDefaultsKeys {
    static let firstStation = "firstStation"
    static let secondStation = "secondStation"
    static let moreInfoSelectedStation = "moreInfoSelectedStation"
}

struct AppEndPoints {
    static let getStationsURL = "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML"
    static let getTrainsURL = "http://api.irishrail.ie/realtime/realtime.asmx/getCurrentTrainsXML"
    static let getTrainsForStation = "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByNameXML"
}

struct ResponceKeys {
    static let stationDecription = "StationDesc"
    static let stationAlias = "StationAlias"
    static let stationLatitude = "StationLatitude"
    static let stationLongitude = "StationLongitude"
    static let stationCode = "StationCode"
    static let stationID = "StationId"
    static let trainStatus = "TrainStatus"
    static let trainLatitude = "TrainLatitude"
    static let trainLongitude = "TrainLongitude"
    static let trainCode = "TrainCode"
    static let trainDate = "TrainDate"
    static let publicMessage = "PublicMessage"
    static let trainDirection = "Direction"
    static let expectedArrival = "Exparrival"
    static let trainDestination = "Destination"
    static let stationDataTrainCode = "Traincode"
    
}
