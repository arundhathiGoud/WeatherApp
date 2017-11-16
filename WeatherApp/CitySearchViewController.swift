//
//  CitySearchViewController.swift
//  WeatherApp
//
//  Created by Four Arms on 14/11/17.
//  Copyright © 2017 Tilicho Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import GooglePlaces
import Alamofire
import ObjectMapper


class CitySearchViewController:  UIViewController, GMSAutocompleteFetcherDelegate {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.keyboardDismissMode = .onDrag
            tableView.estimatedRowHeight = 44
            tableView.delegate = self
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! 
    
    lazy var fetcher: GMSAutocompleteFetcher = {
   
        let onlyCitiesFilter = GMSAutocompleteFilter()
        onlyCitiesFilter.type = .city
        let f = GMSAutocompleteFetcher(bounds: nil, filter: onlyCitiesFilter)
        f.delegate = self
        return f
    }()
    
    let dB = DisposeBag()
    
    var onCityPredictionSelected: ((_ prediction: GMSAutocompletePrediction) -> Void)!
    var searchResults: Variable<[GMSAutocompletePrediction]> = Variable([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //OnClickCancel
        searchBar.rx.cancelButtonClicked.subscribe { _ in
            self.searchBar.resignFirstResponder()
            self.navigationController?.dismiss(animated: true, completion: nil)
            }.addDisposableTo(dB)
        
        //OnTextChange
        let fetchCityListSuggestions = searchBar.rx.text.throttle(0.1, scheduler: MainScheduler.instance)
        fetchCityListSuggestions.subscribe { (event) in
            if (event.element! != "" && event.element != nil) {
                self.fetcher.sourceTextHasChanged(event.element!)
            } else {
                self.searchResults.value = []
            }
        }.addDisposableTo(dB)
        
        //OnDidSelectTableView
        tableView
            .rx
            .modelSelected(GMSAutocompletePrediction.self)
            .subscribe(onNext: { 
                prediction in
                
                self.searchBar.resignFirstResponder()
                self.dismiss(animated: true, completion: nil)
                self.onCityPredictionSelected(prediction)
            })
            .addDisposableTo(dB)
        
        //DesignCellForTableView
        searchResults.asObservable().bindTo(tableView
            .rx
            .items(cellIdentifier: "SearchLocaltionTableViewCell",
                   cellType: SearchLocaltionTableViewCell.self)) {
                    row, prediction, cell in
                    cell.locationTitle.attributedText = prediction.attributedPrimaryText
                    cell.locationAreaLabel.attributedText = prediction.attributedSecondaryText
            }
            .addDisposableTo(dB)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {

        searchResults.value = predictions
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        // No Op
    }
}

extension CitySearchViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
