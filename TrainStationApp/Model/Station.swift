//
//  Station.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 1.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import Foundation

struct Station: Codable {
    let description: String
    let alias: String?
    let latitude: Double
    let longitude: Double
    let code: String
    let id: Int
}
