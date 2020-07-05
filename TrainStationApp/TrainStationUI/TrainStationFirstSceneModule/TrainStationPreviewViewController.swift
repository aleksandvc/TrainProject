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
    
    var isFirstTextfieldOpened = false
    
    var firstStation: Station?
    var secondStation: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfoButton.layer.cornerRadius = 5
    }
    //MARK: Private functions
    private func toggleMainButton() {
        let shouldBeEnabled = fromStation != nil && toStation != nil
        getInfoButton.backgroundColor = shouldBeEnabled ? UIColor.systemBlue : UIColor.systemGray
        getInfoButton.isEnabled = shouldBeEnabled
    }
    
    private func presentSearchableOptionsVC() {
        let searchableVC = SearchableOptionsViewController(nibName: "\(SearchableOptionsViewController.self)", bundle: nil)
        searchableVC.modalPresentationStyle = .formSheet
        searchableVC.delegate = self
        searchableVC.viewModel = SearchableOptionsViewModel()
        DispatchQueue.main.async {
            self.present(searchableVC, animated: true, completion: nil)
        }
    }
    
    private func presentResultsVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let resultsVC = storyboard.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController else { return }
        resultsVC.viewModel = ResultsViewModel()
        DispatchQueue.main.async {
            self.present(resultsVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapGetInfoButton(_ sender: Any) {
        presentResultsVC()
    }    
}

extension TrainStationPreviewViewController: SearchableOptionsDelegate {
    var isFirstTextfieldTapped: Bool {
        return isFirstTextfieldOpened
    }
    
    var fromStation: Station? {
        get {
            return firstStation
        }
        set {
            firstStation = newValue
        }
    }
    
    var toStation: Station? {
        get {
            return secondStation
        }
        set {
            secondStation = newValue
        }
    }
    
    func setStationToFirstTextField() {
        guard let station = fromStation else { return }
        if station.code == toStation?.code {
            fromStationTextField.text = "Please choose different than the other choosen station"
            fromStation = nil
        } else {
            fromStationTextField.text = "\(station.description) - code: \(station.code)"
            UserDefaults.standard.set(try? PropertyListEncoder().encode(station), forKey: UserDefaultsKeys.fromStation)
        }
        toggleMainButton()
    }
    
    func setStationToSecondTextField() {
        guard let station = toStation else { return }
        if station.code == fromStation?.code {
            toStationTextField.text = "Please choose different than the other choosen station"
            toStation = nil
        } else {
            toStationTextField.text = "\(station.description) - code: \(station.code)"
            UserDefaults.standard.set(try? PropertyListEncoder().encode(station), forKey: UserDefaultsKeys.toStation)
        }
        toggleMainButton()
    }
    
    
}

extension TrainStationPreviewViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isFirstTextfieldOpened = textField.tag == 1 ? true : false
        presentSearchableOptionsVC()
        
        return false
    }
}
