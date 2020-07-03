//
//  TrainStationPreviewViewController.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 1.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import UIKit
import Foundation

class TrainStationPreviewViewController: UIViewController {
    
    @IBOutlet weak var fromStationTextField: UITextField!
    @IBOutlet weak var toStationTextField: UITextField!
    @IBOutlet weak var getInfoButton: UIButton!
    
    let viewModel = TrainStationViewModel()
    
    var isFirstTextfieldOpened = false
    
    var firstStation: Station?
    var secondStation: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfoButton.layer.cornerRadius = 5
    }
    
    func presentSearchableOptionsVC() {
        let searchableVC = SearchableOptionsViewController(nibName: "\(SearchableOptionsViewController.self)", bundle: nil)
        searchableVC.modalPresentationStyle = .formSheet
        searchableVC.delegate = self
        searchableVC.viewModel = SearchableOptionsViewModel()
        DispatchQueue.main.async {
            self.present(searchableVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapGetInfoButton(_ sender: Any) {
        
    }    
}

extension TrainStationPreviewViewController: SearchableOptionsDelegate {
    var isFirstTextfieldTapped: Bool {
        return isFirstTextfieldOpened
    }
    
    var firstSelectedStation: Station? {
        get {
            return firstStation
        }
        set {
            firstStation = newValue
        }
    }
    
    var secondSelectedStation: Station? {
        get {
            return secondStation
        }
        set {
            secondStation = newValue
        }
    }
    
    func setStationToFirstTextField() {
        guard let station = firstSelectedStation else { return }
        if station.code == secondSelectedStation?.code {
            fromStationTextField.text = "Please choose different than the other choosen station"
            firstSelectedStation = nil
        } else {
            fromStationTextField.text = "\(station.description) - code: \(station.code)"
        }
    }
    
    func setStationToSecondTextField() {
        guard let station = secondSelectedStation else { return }
        if station.code == firstSelectedStation?.code {
            toStationTextField.text = "Please choose different than the other choosen station"
            secondSelectedStation = nil
        } else {
            toStationTextField.text = "\(station.description) - code: \(station.code)"
        }
    }
    
    
}

extension TrainStationPreviewViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isFirstTextfieldOpened = textField.tag == 1 ? true : false
        presentSearchableOptionsVC()
        
        return false
    }
}
