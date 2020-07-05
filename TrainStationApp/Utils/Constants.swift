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
}

struct AppEndPoints {
    static let getStationsURL = "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML"
    static let getTrainsURL = "http://api.irishrail.ie/realtime/realtime.asmx/getCurrentTrainsXML"
}
