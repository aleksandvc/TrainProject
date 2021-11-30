//
//  ResultsForStationTableViewCell.swift
//  TrainStationApp
//
//  Created by Sasha Belov on 28.11.21.
//  Copyright © 2021 alexander.tsvetanov. All rights reserved.
//

import UIKit

class ResultsForStationTableViewCell: UITableViewCell {

    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var trainCodeLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var expectedArrivalLabel: UILabel!
    
    func populateWith(data: StationData) {
        directionLabel.text = "Train direction: \(data.direction)"
        trainCodeLabel.text = "Train code: \(data.trainCode)"
        destinationLabel.text = "Train destination: \(data.destination)"
        expectedArrivalLabel.text = "Expected arrival: \(data.expectedArrival)"
    }
}
