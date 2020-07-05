//
//  Constants.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 2.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import Foundation

struct NotificationNames {
    static let userDidDownloadedStations = NSNotification.Name("userDidDownloadedStations")
    
}

struct UserDefaultsKeys {
    static let fromStation = "fromStation"
    static let toStation = "toStation"
    static let date = "date"
}

struct AppEndPoints {
    static let getStationsURL = "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML"
    static let getTrainsURL = "http://api.irishrail.ie/realtime/realtime.asmx/getCurrentTrainsXML"
}
