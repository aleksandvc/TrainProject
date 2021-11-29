//
//  UIViewControllerExtension.swift
//  TrainStationApp
//
//  Created by Sasha Belov on 28.11.21.
//  Copyright © 2021 alexander.tsvetanov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    //Showing small loading circle while the request is executing
    func getActivityIndicator() -> UIActivityIndicatorView {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        return indicator
    }
    
    func showErrorPromt(errorDesc: String) {
        let alert = UIAlertController(title: "Something went wrong", message: errorDesc, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }
}
