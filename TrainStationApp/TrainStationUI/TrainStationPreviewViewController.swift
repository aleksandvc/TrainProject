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
    
    var firstSelectedCountry: Station?
    var secondSelectedCountry: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func presentSearchableOptionsVC() {
        let searchableVC = SearchableOptionsViewController(nibName: "\(SearchableOptionsViewController.self)", bundle: nil)
        searchableVC.modalPresentationStyle = .formSheet
        searchableVC.delegate = self
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
            return firstSelectedCountry
        }
        set {
            firstSelectedCountry = newValue
        }
    }
    
    var secondSelectedStation: Station? {
        get {
            return secondSelectedCountry
        }
        set {
            secondSelectedCountry = newValue
        }
    }
    
    func setStationToFirstTextField() {
        fromStationTextField.text = firstSelectedCountry?.description
    }
    
    func setStationToSecondTextField() {
        toStationTextField.text = secondSelectedCountry?.description
    }
    
    
}

extension TrainStationPreviewViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isFirstTextfieldOpened = textField.tag == 1 ? true : false
        presentSearchableOptionsVC()
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
