//
//  ResultsForStationViewController.swift
//  TrainStationApp
//
//  Created by Sasha Belov on 28.11.21.
//  Copyright © 2021 alexander.tsvetanov. All rights reserved.
//

import UIKit
import Bondage

protocol ResultsForStationNetworkingProtocol {
    var trains: BindableArray<StationData> { get set }
    func getTrains(completion: ((String?)->())?)
}

class ResultsForStationViewController: UIViewController {

    @IBOutlet weak var noAvailableTrainsView: UIView!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var mainButton: UIButton!
    
    var viewModel: ResultsForStationNetworkingProtocol? = nil
    
    var activityIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        mainButton.layer.cornerRadius = 5
        setupTableView()
        activityIndicator = getActivityIndicator()
        viewModel?.trains.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.resultsTableView.reloadData()
            }
        }
        
        viewModel?.trains.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.resultsTableView.reloadData()
            }
        }
        
        DispatchQueue.main.async {
            self.activityIndicator?.startAnimating()
        }

        viewModel?.getTrains() { errorDescription in
            DispatchQueue.main.async {
                self.resultsTableView.isHidden = self.viewModel?.trains.value.count == 0
                self.activityIndicator?.stopAnimating()
            }
            guard let errorDesc = errorDescription else { return }
            self.showErrorPromt(errorDesc: errorDesc)
        }
    }

    private func setupTableView() {
        let nib = UINib(nibName: "\(ResultsForStationTableViewCell.self)", bundle: nil)
        resultsTableView.register(nib, forCellReuseIdentifier: "\(ResultsForStationTableViewCell.self)")
    }
    
    @IBAction func didTapMainButton(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension ResultsForStationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.trains.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ResultsForStationTableViewCell.self)") as? ResultsForStationTableViewCell, let train = viewModel?.trains.value[indexPath.row] else { return UITableViewCell() }
        
        cell.populateWith(data: train)
        return cell
    }
    
}

extension ResultsForStationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
}

