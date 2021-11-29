//
//  SearchableOptionsViewController.swift
//  WacomCloud
//
//  Created by alexander.tsvetanov on 29.05.20.
//  Copyright © 2020 Wacom. All rights reserved.
//

import UIKit
import Bondage
import Alamofire

protocol SearchableOptionsNetworkingProtocol {
    var trainStations: BindableArray<Station> { get set }
    var searchedTrainStations:[Station] { get set }
    func getStations(completion: ((String?)->())?)
}

protocol SearchableOptionsDelegate: AnyObject {
    var isFirstTextfieldTapped: Bool { get }
    var selectedStationTextFieldTapped: Bool { get }
    var firstStation: Station? { get set }
    var secondStation: Station? { get set }
    var moreInfoStation: Station? { get set }
    func setStationToFirstTextField()
    func setStationToSecondTextField()
    func setSelectedForMoreInfoStationToTextField()
}

class SearchableOptionsViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var entriesTableView: UITableView!
    
    var activityIndicator: UIActivityIndicatorView?
    
    var isSearching = false
    
    var viewModel: SearchableOptionsNetworkingProtocol? = nil
    
    weak var delegate: SearchableOptionsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 1
        
        activityIndicator = getActivityIndicator()
        
        viewModel?.trainStations.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.entriesTableView.reloadData()
            }
        }
        
        DispatchQueue.main.async {
            self.activityIndicator?.startAnimating()
        }
        viewModel?.getStations() { errorDescription in
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
            }
            
            guard let errorDesc = errorDescription else { return }
            self.showErrorPromt(errorDesc: errorDesc)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let isFirstTextfieldTapped = delegate?.isFirstTextfieldTapped else { return }
        DispatchQueue.main.async {
            isFirstTextfieldTapped ? self.delegate?.setStationToFirstTextField() : self.delegate?.setStationToSecondTextField()
            self.delegate?.setSelectedForMoreInfoStationToTextField()
        }
    }
}

extension SearchableOptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let isFirstTextfieldTapped = delegate?.isFirstTextfieldTapped, let isSelectedStationTextFieldTapped = delegate?.selectedStationTextFieldTapped else { return }
        if isFirstTextfieldTapped {
            delegate?.firstStation = isSearching ? viewModel?.searchedTrainStations[indexPath.row] : viewModel?.trainStations.value[indexPath.row]
        } else if isSelectedStationTextFieldTapped  {
            delegate?.moreInfoStation = isSearching ? viewModel?.searchedTrainStations[indexPath.row] : viewModel?.trainStations.value[indexPath.row]
        } else {
            delegate?.secondStation = isSearching ? viewModel?.searchedTrainStations[indexPath.row] : viewModel?.trainStations.value[indexPath.row]
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension SearchableOptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return isSearching ? viewModel.searchedTrainStations.count : viewModel.trainStations.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return  UITableViewCell() }
        let cell = UITableViewCell()
        let stationInfo = isSearching ? "\(viewModel.searchedTrainStations[indexPath.row].description) - code: \(viewModel.searchedTrainStations[indexPath.row].code)" : "\(viewModel.trainStations.value[indexPath.row].description) - code: \(viewModel.trainStations.value[indexPath.row].code)"
        cell.textLabel?.text = stationInfo
        if let fontName = cell.textLabel?.font.familyName {
            cell.textLabel?.font = UIFont(name: fontName, size: 15)
        }
        
        return cell
    }
}

extension SearchableOptionsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard var viewModel = viewModel else { return }
        viewModel.searchedTrainStations = viewModel.trainStations.value.filter({$0.description.lowercased().prefix(searchText.count) == searchText.lowercased()})
        isSearching = true
        DispatchQueue.main.async {
            self.entriesTableView.reloadData()
        }
    }
}
