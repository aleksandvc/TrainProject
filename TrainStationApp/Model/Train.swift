//
//  Train.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 5.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import Foundation

enum TrainStatus: String {
    case N = "not running"
    case R = "running"
}

struct Train {
    let trainStatus: TrainStatus
    let latitude: Double
    let longitude: Double
    let code: String
    let date: String
    let publicMessage: String
    let direction: String
}
