//
//  SearchableOptionsViewController.swift
//  WacomCloud
//
//  Created by alexander.tsvetanov on 29.05.20.
//  Copyright © 2020 Wacom. All rights reserved.
//

import UIKit

protocol SearchableOptionsDelegate: AnyObject {
    var isFirstTextfieldTapped: Bool { get }
    var firstSelectedStation: Station? { get set }
    var secondSelectedStation: Station? { get set }
    func setStationToFirstTextField()
    func setStationToSecondTextField()
}

class SearchableOptionsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var entriesTableView: UITableView!
    
    let networkManager = NetworkManager()
    
    var stations: [Station] = []
    var searchedStations:[Station] = []
    
    var activityIndicator: UIActivityIndicatorView?
    
    var currentParsingElement = ""
    var stationDescription = ""
    var stationAlias = ""
    var stationLatitude = 0.0
    var stationLongitude = 0.0
    var stationCode = ""
    var stationId = 0
    
    var isSearching = false
    
    public weak var delegate: SearchableOptionsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        searchBar.layer.borderColor = UIColor.systemGray.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.layer.cornerRadius = 10.0
        searchBar.clipsToBounds = true
        
        activityIndicator = getActivityIndicator()
        activityIndicator?.startAnimating()
        networkManager.getAllStations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let isFirstTextfieldTapped = delegate?.isFirstTextfieldTapped else { return }
        isFirstTextfieldTapped ? delegate?.setStationToFirstTextField() : delegate?.setStationToSecondTextField()
    }
    
//    private func storeStations(savedStations: Dictionary<String, Any>, completion: ()->()) {
//        var unsortedStations:[Station] = []
//        for (key, value) in savedStations {
//
//            guard let stationDesc = value as? String else { return }
//            let station = Station(countryCode: key, countryName: countryName)
//            unsortedStations.append(station)
//        }
//
//        sortStations(unsortedStations: unsortedStations, completion: completion)
//    }
//
//    private func sortStations(unsortedStations: [Station], completion: ()->()) {
//        stations = unsortedStations.sorted(by: { $0.description < $1.description })
//        completion()
//    }
    
    private func getActivityIndicator() -> UIActivityIndicatorView {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return indicator
    }
}

extension SearchableOptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let isFirstTextfieldTapped = delegate?.isFirstTextfieldTapped else { return }
        if isFirstTextfieldTapped {
            delegate?.firstSelectedStation = isSearching ? searchedStations[indexPath.row] : stations[indexPath.row]
        } else {
            delegate?.secondSelectedStation = isSearching ? searchedStations[indexPath.row] : stations[indexPath.row]
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension SearchableOptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchedStations.count : stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
           
        cell.textLabel?.text = isSearching ? searchedStations[indexPath.row].description : stations[indexPath.row].description
       
        return cell
    }
}

extension SearchableOptionsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedStations = stations.filter({$0.description.lowercased().prefix(searchText.count) == searchText.lowercased()})
        isSearching = true
        entriesTableView.reloadData()
    }
}

extension SearchableOptionsViewController: XMLParserDelegate {
    
        //MARK:- XML Delegate methods
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            currentParsingElement = elementName
            if elementName == "ArrayOfObjStation" {
                print("Started parsing...")
            }
        }
          
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            
            if (!foundedChar.isEmpty) {
               
                if currentParsingElement == "StationDesc" {
                    stationDescription = foundedChar
                }
                else if currentParsingElement == "StationAlias" {
                    stationAlias = foundedChar
                }
                else if currentParsingElement == "StationLatitude" {
                    if let doubleLatitude = Double(foundedChar) {
                        stationLatitude = doubleLatitude
                    }
                }
                else if currentParsingElement == "StationLongitude" {
                    if let doubleLongitude = Double(foundedChar) {
                        stationLongitude = doubleLongitude
                    }
                }
                else if currentParsingElement == "StationCode" {
                    stationCode = foundedChar
                }
                else if currentParsingElement == "StationId" {
                    if let intId = Int(foundedChar) {
                        stationId = intId
                        let station = Station(description: stationDescription, alias: stationAlias, latitude: stationLatitude, longitude: stationLongitude, code: stationCode, id: stationId)
                        self.stations.append(station)
                    }
                }
            }
            
    }
          
        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            if elementName == "ArrayOfObjStation" {
                print("Ended parsing...")
            }
        }
          
        func parserDidEndDocument(_ parser: XMLParser) {
            DispatchQueue.main.async {
                self.entriesTableView.reloadData()
                self.activityIndicator?.stopAnimating()
            }
        }
          
        func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
            print("parseErrorOccurred: \(parseError)")
        }

}
