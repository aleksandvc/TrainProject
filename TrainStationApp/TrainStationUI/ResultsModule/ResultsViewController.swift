//
//  ResultsViewController.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 4.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import UIKit
import Bondage

protocol ResultsNetworkingProtocol {
    var isStationDataNeeded: Bool { get set }
    var trains: BindableArray<Train> { get set }
    var trainsForStation: BindableArray<StationData> { get set }
    func getTrains(completion: ((String?)->())?)
}

class ResultsViewController: UIViewController {
    
    @IBOutlet private weak var resultsTableView: UITableView!
    @IBOutlet private weak var anotherRouteButton: UIButton!
    @IBOutlet private weak var noAvailableTrainsView: UIView!
    @IBOutlet weak var noAvailableLabel: UILabel!
    
    var viewModel: ResultsNetworkingProtocol? = nil
    
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        anotherRouteButton.layer.cornerRadius = 5
        setupTableView()
        activityIndicator = getActivityIndicator()
        
        if viewModel?.isStationDataNeeded ?? false {
            viewModel?.trainsForStation.bind { [weak self] _ in
                DispatchQueue.main.async {
                    self?.resultsTableView.reloadData()
                }
            }
        } else {
            viewModel?.trains.bind { [weak self] _ in
                DispatchQueue.main.async {
                    self?.resultsTableView.reloadData()
                }
            }
        }
        
        DispatchQueue.main.async {
            self.activityIndicator?.startAnimating()
        }
        
        viewModel?.getTrains() { errorDescription in
            DispatchQueue.main.async {
                guard let isStationDataNeeded = self.viewModel?.isStationDataNeeded else { return }
                self.resultsTableView.isHidden = !isStationDataNeeded ? self.viewModel?.trains.value.count == 0 : self.viewModel?.trainsForStation.value.count == 0
                self.activityIndicator?.stopAnimating()
            }
            guard let errorDesc = errorDescription else { return }
            self.showErrorPromt(errorDesc: errorDesc)
        }
    }
                                    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let isStationDataNeeded = viewModel?.isStationDataNeeded else { return }
        DispatchQueue.main.async {
            self.anotherRouteButton.setTitle(!isStationDataNeeded ? "Choose another route" : "Choose another station", for: .normal)
            self.noAvailableLabel.text = isStationDataNeeded ? "No available trains for this station today." : "No available trains between these station today."
        }
    }
    
    private func setupTableView() {
        guard let isStationDataNeeded = viewModel?.isStationDataNeeded else { return }
        let nib = UINib(nibName: isStationDataNeeded ? "\(ResultsForStationTableViewCell.self)" : "\(ResultsTableViewCell.self)", bundle: nil)
        resultsTableView.register(nib, forCellReuseIdentifier: isStationDataNeeded ? "\(ResultsForStationTableViewCell.self)" : "\(ResultsTableViewCell.self)")
    }
    
    @IBAction func didTapAnotherRouteButton(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let isStationDataNeeded = viewModel?.isStationDataNeeded else { return 0 }
        return isStationDataNeeded ? (viewModel?.trainsForStation.value.count ?? 0) : (viewModel?.trains.value.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let isStationDataNeeded = viewModel?.isStationDataNeeded else { return UITableViewCell() }
        if !isStationDataNeeded {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ResultsTableViewCell.self)") as? ResultsTableViewCell, let train = viewModel?.trains.value[indexPath.row] else { return UITableViewCell() }
            cell.populateWith(data: train)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ResultsForStationTableViewCell.self)") as? ResultsForStationTableViewCell, let train = viewModel?.trainsForStation.value[indexPath.row] else { return UITableViewCell() }
            cell.populateWith(data: train)
            return cell
        }
    }
}

extension ResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
}

