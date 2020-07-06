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
    var trains: BindableArray<Train> { get set }
    func getTrains(presenter: UIViewController, completion: (()->())?)
}

class ResultsViewController: UIViewController {

    @IBOutlet private weak var resultsTableView: UITableView!
    @IBOutlet private weak var anotherRouteButton: UIButton!
    @IBOutlet private weak var noAvailableTrainsView: UIView!
    
    var viewModel: ResultsNetworkingProtocol? = nil
    
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        anotherRouteButton.layer.cornerRadius = 5
        setupTableView()
        activityIndicator = getActivityIndicator()
        viewModel?.trains.bind { [weak self] _ in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.noAvailableTrainsView.isHidden = strongSelf.viewModel?.trains.value.count != 0
                self?.resultsTableView.reloadData()
            }
        }
        
        DispatchQueue.main.async {
            self.activityIndicator?.startAnimating()
        }
        
        viewModel?.getTrains(presenter: self) {
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
            }
        }
    }
    
    //Showing small loading circle while the request is executing
    private func getActivityIndicator() -> UIActivityIndicatorView {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        return indicator
    }
    
    private func setupTableView() {
        
        let nib = UINib(nibName: "\(ResultsTableViewCell.self)", bundle: nil)
        resultsTableView.register(nib, forCellReuseIdentifier: "\(ResultsTableViewCell.self)")
        
    }

    @IBAction func didTapAnotherRouteButton(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.trains.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ResultsTableViewCell.self)") as? ResultsTableViewCell, let train = viewModel?.trains.value[indexPath.row] else { return UITableViewCell() }
       
        cell.populateWith(data: train)
        return cell
    }
    
}

extension ResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
}

