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
    
    @IBOutlet private weak var firstStationTextField: UITextField!
    @IBOutlet private weak var secondStationTextField: UITextField!
    @IBOutlet private weak var getInfoButton: UIButton!
    @IBOutlet weak var selectedStationTextField: UITextField!
    @IBOutlet weak var showTrainsButton: UIButton!
    
    var isFirstTextfieldOpened = false
    var isSelectedStationTextFieldTapped = false
    
    var firstSelectedStation: Station?
    var secondselectedStation: Station?
    
    var moreInfoSelectedStation: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfoButton.layer.cornerRadius = 5
    }
    //MARK: Private functions
    private func toggleMainButton() {
        let shouldBeEnabled = firstSelectedStation != nil && secondselectedStation != nil
        getInfoButton.backgroundColor = shouldBeEnabled ? UIColor.systemBlue : UIColor.systemGray
        getInfoButton.isEnabled = shouldBeEnabled
    }
    
    private func toggleShowTrainsButton() {
        let shouldBeEnabled = moreInfoSelectedStation != nil
        showTrainsButton.backgroundColor = shouldBeEnabled ? UIColor.systemBlue : UIColor.systemGray
        showTrainsButton.isEnabled = shouldBeEnabled
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
    
    private func presentResultsForStationVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let resultsVC = storyboard.instantiateViewController(withIdentifier: "ResultsForStationViewController") as? ResultsForStationViewController else { return }
        resultsVC.viewModel = ResultsForStationViewModel(selectedStation: moreInfoSelectedStation!)
        DispatchQueue.main.async {
            self.present(resultsVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapGetInfoButton(_ sender: Any) {
        presentResultsVC()
    }
    
    @IBAction func didTapShowTrainsButton(_ sender: Any) {
        presentResultsForStationVC()
    }
}

extension TrainStationPreviewViewController: SearchableOptionsDelegate {
    var isFirstTextfieldTapped: Bool {
        return isFirstTextfieldOpened
    }
    
    var selectedStationTextFieldTapped: Bool {
        return isSelectedStationTextFieldTapped
    }
    
    var firstStation: Station? {
        get {
            return firstSelectedStation
        }
        set {
            firstSelectedStation = newValue
        }
    }
    
    var secondStation: Station? {
        get {
            return secondselectedStation
        }
        set {
            secondselectedStation = newValue
        }
    }
    
    var moreInfoStation: Station? {
        get {
            return moreInfoSelectedStation
        }
        set {
            moreInfoSelectedStation = newValue
        }
    }
    
    func setStationToFirstTextField() {
        guard let station = firstSelectedStation else { return }
        if station.code == secondselectedStation?.code {
            firstStationTextField.text = "Please choose different than the other choosen station"
            firstStation = nil
        } else {
            firstStationTextField.text = "\(station.description) - code: \(station.code)"
            UserDefaults.standard.set(try? PropertyListEncoder().encode(station), forKey: UserDefaultsKeys.firstStation)
        }
        toggleMainButton()
    }
    
    func setStationToSecondTextField() {
        guard let station = secondselectedStation else { return }
        if station.code == firstSelectedStation?.code {
            secondStationTextField.text = "Please choose different than the other choosen station"
            secondselectedStation = nil
        } else {
            secondStationTextField.text = "\(station.description) - code: \(station.code)"
            UserDefaults.standard.set(try? PropertyListEncoder().encode(station), forKey: UserDefaultsKeys.secondStation)
        }
        toggleMainButton()
    }
    
    func setSelectedForMoreInfoStationToTextField() {
        guard let station = moreInfoSelectedStation else { return }
        
        selectedStationTextField.text = "\(station.description) - code: \(station.code)"
        UserDefaults.standard.set(try? PropertyListEncoder().encode(station), forKey: UserDefaultsKeys.moreInfoSelectedStation)
        toggleShowTrainsButton()
    }
    
}

extension TrainStationPreviewViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isFirstTextfieldOpened = textField.tag == 1
        isSelectedStationTextFieldTapped = textField.tag == 3
        presentSearchableOptionsVC()
        
        return false
    }
}
