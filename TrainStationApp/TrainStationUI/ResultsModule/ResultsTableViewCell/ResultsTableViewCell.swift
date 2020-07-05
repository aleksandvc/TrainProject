//
//  ResultsTableViewCell.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 5.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    
    func populateWith(data: Train) {
        statusLabel.text = "Status: \(data.trainStatus.rawValue)"
        codeLabel.text = "Code: \(data.code)"
        dateLabel.text = data.date
        messageLabel.text = data.publicMessage
        directionLabel.text = "Direction: \(data.direction)"
    }
}
