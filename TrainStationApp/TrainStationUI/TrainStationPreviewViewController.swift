//
//  TrainStationPreviewViewController.swift
//  TrainStationApp
//
//  Created by alexander.tsvetanov on 1.07.20.
//  Copyright © 2020 alexander.tsvetanov. All rights reserved.
//

import UIKit
import Foundation

class TrainStationPreviewViewController: UIViewController, XMLParserDelegate {
     
    @IBOutlet weak var fromStationTextField: UITextField!
    @IBOutlet weak var toStationTextField: UITextField!
    @IBOutlet weak var getInfoButton: UIButton!
   
    var currentParsingElement = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML") else { return }
        
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
//        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
//        request.httpMethod = "GET"
        //request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            print(error ?? "No error")
            print(response ?? "No response")
            
            guard let data = data else { return }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            
        })
        
        task.resume()
    }
    
    @IBAction func didTapGetInfoButton(_ sender: Any) {
        
    }
    
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
            print(foundedChar)
//            if currentParsingElement == "IP" {
//                ipAddr += foundedChar
//            }
//            else if currentParsingElement == "CountryCode" {
//                countryCode += foundedChar
//            }
//            else if currentParsingElement == "CountryName" {
//                countryName += foundedChar
//            }
//            else if currentParsingElement == "Latitude" {
//                latitude += foundedChar
//            }
//            else if currentParsingElement == "Longitude" {
//                longitude += foundedChar
//            }
        }
          
    }
      
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "ArrayOfObjStation" {
            print("Ended parsing...")
              
        }
    }
      
    func parserDidEndDocument(_ parser: XMLParser) {
//        DispatchQueue.main.async {
//             Update UI
//            self.displayOnUI()
//
//        }
    }
      
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
}
