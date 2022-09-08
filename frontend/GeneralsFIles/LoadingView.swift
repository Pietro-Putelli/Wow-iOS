//
//  LoadingView.swift
//  eventsProject
//
//  Created by Pietro Putelli on 11/11/2018.
//  Copyright © 2018 Pietro Putelli. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

struct HomeLoadingView {
    var backgroundView: UIView
    var activityIndicator: NVActivityIndicatorView
}

struct ConnectionErrorLoadingView {
    var activityIndicatorBackground: UIView
    var activityIndicator: NVActivityIndicatorView
    var errorLabel: UILabel
    var errorLabelBackground: UIView
}

class LoadingView {
    
    class func homeLoadingView(for view: UIView) -> HomeLoadingView {
        let loadingView = UIView()
        let frame = CGRect(origin: view.center, size: CGSize(width: 80, height: 80))
        let color = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1)
        let activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballRotateChase, color: color, padding: nil)
        
        loadingView.frame = CGRect(origin: view.center, size: CGSize(width: 120, height: 120))
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingView.layer.cornerRadius = 12.0
        loadingView.clipsToBounds = true

        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()

        let homeLoadingView = HomeLoadingView(backgroundView: loadingView, activityIndicator: activityIndicator)
        return homeLoadingView
    }
    
    class func connectionErrorLoadingView(for view: UIView) -> ConnectionErrorLoadingView {
        let frame = CGRect(origin: view.center, size: CGSize(width: 80, height: 80))
        let color = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1)
        let activityIndicator = NVActivityIndicatorView(frame: frame, type: .lineScalePulseOut, color: color, padding: nil)
        
        let activityIndicatorView = UIView()
        activityIndicatorView.frame = CGRect(origin: view.center, size: CGSize(width: 120, height: 120))
        activityIndicatorView.center = view.center
        activityIndicatorView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        activityIndicatorView.layer.cornerRadius = 12.0
        activityIndicatorView.clipsToBounds = true
        
        activityIndicator.center = activityIndicatorView.center
        activityIndicator.startAnimating()
        
        let errorLabelBackgorund = UIView()
        errorLabelBackgorund.frame = CGRect(origin: view.center, size: CGSize(width: 220, height: 40))
        errorLabelBackgorund.center = CGPoint(x: view.center.x, y: view.center.y + 2.5 * (errorLabelBackgorund.frame.height))
        errorLabelBackgorund.backgroundColor = activityIndicatorView.backgroundColor
        errorLabelBackgorund.layer.cornerRadius = 12.0
        errorLabelBackgorund.clipsToBounds = true
        
        let errorLabel = UILabel()
        errorLabel.frame = CGRect(origin: errorLabelBackgorund.center, size: CGSize(width: errorLabelBackgorund.frame.width - 20, height: errorLabelBackgorund.frame.height - 10))
        errorLabel.center = errorLabelBackgorund.center
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1)
        errorLabel.font = UIFont(name: "Accuratist", size: 20)
        errorLabel.text = User.language.error_connection
        
        let connectionErrorView = ConnectionErrorLoadingView(activityIndicatorBackground: activityIndicatorView, activityIndicator: activityIndicator, errorLabel: errorLabel, errorLabelBackground: errorLabelBackgorund)
        return connectionErrorView
    }
}
